//
//  Post.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RealmSwift
//MARK - model class for posts
final class Post: Object {
    @objc dynamic var timestamp = Date()
    @objc dynamic var body: String?
    @objc dynamic var imageThumbnails = [UIImage]()
    let imageDataFilename = List<String>()
    
    override static func ignoredProperties() -> [String] {
        return ["imageThumbnails"]
    }
    
    //load images
    func loadThumbnails () {
        self.imageThumbnails = []
        if let filename = self.imageDataFilename.first,
            let image = UIImage.loadImage(with: filename ){
            self.imageThumbnails.append( image )
        }
        
        if self.imageDataFilename.count > 1 {
            let filename = self.imageDataFilename[1]
            if let image = UIImage.loadImage(with: filename ) {
                self.imageThumbnails.append(  image )
                
            }
        }
        
        if self.imageDataFilename.count > 2 {
            let filename = self.imageDataFilename[2]
            if let image = UIImage.loadImage(with: filename ) {
                self.imageThumbnails.append( image )
            }
        }
    }
}

