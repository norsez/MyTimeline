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

extension NSNotification.Name {
    public static let DataDidCreateNewPost = NSNotification.Name(rawValue: "DataDidCreateNewPost")
}

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var composeButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var addButtonImageView: UIImageView!
    var imageViews = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageViews = [self.imageView1, self.imageView2, self.imageView3]
        
        
        //configure the add image button
        let tapToAdd = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        self.addButtonImageView.addGestureRecognizer(tapToAdd)
        
        
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
        
        self.textView.becomeFirstResponder()
    }
    
 
    @IBAction func didPressCreate(_ sender: Any) {
        let post = Post()
        post.timestamp = Date()
        post.body = self.textView.text
        
        //copy each image to app's directory, then store just the file url.
        let copiedImageURLs = self.imageViews
            .compactMap { (iv) -> UIImage? in
                return iv.image
            }.compactMap { (image) -> String? in
                do {
                    return try image.saveOnDisk()
                }catch {
                    print("copy image fails: \(error)")
                    return nil
                }
            }
        
        post.imageDataFilenames.append(objectsIn: copiedImageURLs)
        
        //actually save the new post.
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(post)
            }
            //let every component know about this new post just created.
            NotificationCenter.default.post(name: .DataDidCreateNewPost, object: nil, userInfo: ["post": post])
            
            self.dismiss(animated: true, completion:nil)
            
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
    
    func nextFreeImageView() -> UIImageView? {
        return self.imageViews.filter({ (iv) -> Bool in
            return iv.image == nil
        }).first
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.nextFreeImageView()?.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
