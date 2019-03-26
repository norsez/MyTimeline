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

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var ImageStackView: UIStackView!
    @IBOutlet var composeButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    let MAX_IMAGES = 3
    var addedImages = BehaviorRelay<[UIImage]>(value:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.black.cgColor
        self.textView.layer.borderWidth = 1
        self.textView.layer.cornerRadius = 8
        
        // enable Create button if there's text to work with.
        self.textView.rx.text
            .map { $0 }
            .asObservable()
            .subscribe(onNext: { [weak self] (inputString) in
               self?.composeButton.isEnabled = inputString != nil && !inputString!.isTrimmedEmpty
            })
            .disposed(by: disposeBag)
        
        self.addedImages.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.updateAddedImagesUI()
        })
        
        
        self.textView.becomeFirstResponder()
    }
    
 
    @IBAction func didPressCreate(_ sender: Any) {
        let post = Post()
        post.timestamp = Date()
        post.body = self.textView.text
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(post)
            }
            self.dismiss(animated: true, completion: nil)
        }catch {
            self.alert(error: error)
        }
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK - image picker methods
    @IBAction func showImagePicker () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            var images = self.addedImages.value
            images.append(image)
            self.addedImages.accept( images )
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateAddedImagesUI () {
        for v in self.ImageStackView.subviews {
            v.removeFromSuperview()
        }
        
        for im in self.addedImages.value {
            let iv = UIImageView(image: im)
            iv.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.ImageStackView.addSubview(iv)
        }
    }
}
