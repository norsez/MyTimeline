//
//  PostCreate.swift
//  MyTimeLine
//
//  Created by norsez on 29/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

extension NSNotification.Name {
    public static let DataDidCreateNewPost = NSNotification.Name(rawValue: "DataDidCreateNewPost")
}


//MARK - ViewModel for Compose screen
class ComposeViewModel {
    let post = Post()
    let disposeBag = DisposeBag()
    
    let DEFAULT_BODY = NSAttributedString(string: "What's on your mind?",
                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
    
    var bodyText = Variable<String?>(nil)
    var imageFilenames = Variable<[String]>([])
    
    //MARK - fields binded to the view
    let errorMessage = Variable<String?>(nil)
    let isSuccess = Variable<Bool>(false)
    let newPostCreated = Variable<Post?>(nil)
    
    func validatePost() -> Bool {
        return bodyText.value != nil && !bodyText.value!.isTrimmedEmpty
    }
    
    //action: create post in db
    func createPost(){
        
        if !self.validatePost() {
            self.errorMessage.value = "Post body can't be empty."
            return
        }
        
        self.post.timestamp = Date()
        self.post.body  = self.bodyText.value
        self.post.imageDataFilenames.append(objectsIn: self.imageFilenames.value)
        
        //actually save the new post.
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(post)
            }
            self.isSuccess.value = true
            self.newPostCreated.value = post
        }catch {
            self.errorMessage.value = "\(error)"
        }
    }
    
}
