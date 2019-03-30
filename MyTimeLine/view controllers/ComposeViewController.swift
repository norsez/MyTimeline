//
//  ComposeViewController.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import QuartzCore
import RxCocoa

//MARK: view controller for Compose screen
class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let viewModel = ComposeViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var composeButton: UIBarButtonItem!
    
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var addButtonImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var imageViews = [UIImageView]()
    var selectedImageFilenames = Variable<[String]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViews = [self.imageView1, self.imageView2, self.imageView3]
        
        
        //configure the add image button
        let tapToAdd = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        self.addButtonImageView.addGestureRecognizer(tapToAdd)
        
        
        self.textView.layer.borderColor = UIColor.black.cgColor
        self.textView.layer.borderWidth = 1
        self.textView.layer.cornerRadius = 8
        self.textView.becomeFirstResponder()
        
        self.bindViewToViewModel()
        self.createRxCallback()
    }
    
    
    @IBAction func didPressCreate(_ sender: Any) {
        self.viewModel.createPost()
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK - image picker methods
    @IBAction func showImagePicker () {
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func nextFreeImageView() -> UIImageView? {
        return self.imageViews.filter({ (iv) -> Bool in
            return iv.image == nil
        }).first
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.nextFreeImageView()?.image = image
            do {
                let filename = try image.saveOnDisk()
                var filenames = self.selectedImageFilenames.value
                filenames.append(filename)
                selectedImageFilenames.value = filenames
            }catch {
                debugPrint("\(error)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Reactive wiring
    func bindViewToViewModel() {
        
        self.viewModel.bodyText.asDriver()
            .drive(onNext: { [weak self] (text) in
                self?.placeholderLabel.isHidden = !(text?.isTrimmedEmpty ?? true)
            }).disposed(by: disposeBag)
        
        self.textView.rx.text.orEmpty
            .bind(to: self.viewModel.bodyText )
            .disposed(by: disposeBag)
        
        self.selectedImageFilenames.asObservable()
            .bind(to:  self.viewModel.imageFilenames)
            .disposed(by: disposeBag)
        
    }
    
    func createRxCallback() {
        
        self.viewModel.errorMessage.asObservable()
            .bind {
                [weak self]  errorMsg in
                if let errorMsg = errorMsg {
                    self?.alert(message: errorMsg)
                }
        }.disposed(by: disposeBag)
        
        self.viewModel.isSuccess.asObservable()
            .bind { [weak self] successful in
                if successful {
                    self?.dismiss(animated: true, completion: nil)
                }
        }.disposed(by: disposeBag)
    }
    
}
