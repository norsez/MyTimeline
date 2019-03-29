//
//  PostTimeline.swift
//  MyTimeLine
//
//  Created by norsez on 29/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit

protocol PostTimelineView {
    var imageBox: UIView! {get set}
    var timestampLabel: UILabel! {get set}
    var bodyLabel: UILabel! {get set}
    var imageBoxHeight: NSLayoutConstraint! {get set}
    
}

//MARK - view model for Post used on Timeline
class PostTimelineViewModel {
    let post: Post
    var lastConstraints = [NSLayoutConstraint]()
    var timestampText: String {
        return "\( self.post.timestamp.asTimelineTime )>"
    }
    
    init(with post:Post) {
        self.post = post
    }
    
    func configure(view: PostTimelineView) {
        view.bodyLabel.text = self.post.body ?? ""
        if self.post.imageDataFilenames.count   > 0 && self.post.imageThumbnails.count == 0 {
            //cache thumbnails on post model.
            self.post.loadThumbnails()
        }
        
        for sv in view.imageBox.subviews {
            sv.removeFromSuperview()
        }
        
        let thumbnails = self.post.imageThumbnails
        if self.post.imageThumbnails.count > 0 {
            var constraints = [NSLayoutConstraint]()
            
            if thumbnails.count == 1 {
                let iv = thumbnails.first!.createImageView
                view.imageBox.addSubview(iv)
                constraints = self.singleImageLayout(withImageView: iv)
            }else if thumbnails.count == 2 {
                let iv = thumbnails.first!.createImageView
                let iv2 = thumbnails[1].createImageView
                view.imageBox.addSubview(iv)
                view.imageBox.addSubview(iv2)
                constraints = self.doubleImageLayout(withImageView: iv,
                                                     anotherImageView: iv2)
            }else if thumbnails.count == 3 {
                let iv = thumbnails.first!.createImageView
                let iv2 = thumbnails[1].createImageView
                let iv3 = thumbnails[2].createImageView
                view.imageBox.addSubview(iv)
                view.imageBox.addSubview(iv2)
                view.imageBox.addSubview(iv3)
                constraints = self.tripleImageLayout(withImageView: iv,
                                                     imageView2: iv2,
                                                     imageView3: iv3)
            }else {
                print("doesn't support more than 3 images")
            }
            
            self.lastConstraints.removeAll()
            self.lastConstraints.append(contentsOf: constraints)
            view.imageBox.addConstraints(constraints)
            view.imageBoxHeight.constant = 180
        }else {
            view.imageBox.removeConstraints(self.lastConstraints)
            view.imageBoxHeight.constant = 0
        }
        
    }
    //
    func singleImageLayout(withImageView iv: UIImageView) -> [NSLayoutConstraint] {
        
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        let views: [String:Any] = ["iv": iv]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        return constraints
    }
    
    func doubleImageLayout(withImageView iv: UIImageView, anotherImageView iv2: UIImageView) -> [NSLayoutConstraint] {
        
        let views: [String:Any] = ["iv2": iv2, "iv": iv]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-[iv2(==iv)]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv2]-|", options: [], metrics: nil, views: views)
        return constraints
    }
    
    func tripleImageLayout(withImageView iv: UIImageView, imageView2 iv2: UIImageView, imageView3 iv3: UIImageView) -> [NSLayoutConstraint] {
        let views: [String:Any] = ["iv2": iv2, "iv": iv, "iv3": iv3]
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-[iv2(==iv)]-|", options: [], metrics: nil, views: views)
        constraints += [NSLayoutConstraint(item: iv3, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: iv2, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: iv3, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: iv2, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)]
        
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv2]-[iv3(==iv2)]-|", options: [], metrics: nil, views: views)
        return constraints
        
    }
    
}
//MARK - convenient methods
extension UIImage {
    var createImageView: UIImageView {
        let iv = UIImageView(image: self)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }
}


//load thumbnails from disk
extension Post {
    
    //load images
    func loadThumbnails () {
        
        self.imageThumbnails = []
        if let filename = self.imageDataFilenames.first,
            let image = UIImage.loadImage(with: filename ){
            self.imageThumbnails.append( image )
        }
        
        if self.imageDataFilenames.count > 1 {
            let filename = self.imageDataFilenames[1]
            if let image = UIImage.loadImage(with: filename ) {
                self.imageThumbnails.append(  image )
                
            }
        }
        
        if self.imageDataFilenames.count > 2 {
            let filename = self.imageDataFilenames[2]
            if let image = UIImage.loadImage(with: filename ) {
                self.imageThumbnails.append( image )
            }
        }
        
    }
}
