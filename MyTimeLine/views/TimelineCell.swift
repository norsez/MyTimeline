//
//  TimelineCell.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxSwift


//MARK - view for timeline cell
class TimelineCell: UITableViewCell {
    
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var imageBox: UIView!
    @IBOutlet var imageBoxHeight: NSLayoutConstraint!
    
    var post: Post? = nil
    var lastImageBoxConstraints = [NSLayoutConstraint]()
    func display(post: Post) {
        self.post = post
        self.bodyLabel.text = post.body
        self.timestampLabel.text = "\(post.timestamp.asTimelineTime) >"
        
        if (self.post?.imageDataFilenames.count ?? 0)  > 0 && (self.post?.imageThumbnails.count ?? 0) == 0 {
            //cache thumbnails on post model.
            self.post?.loadThumbnails()
            
        }
        self.layoutImages()
        
        
    }
    
    override func prepareForReuse() {
        self.bodyLabel.text = nil
        self.imageBoxHeight.constant = 0
        for v in self.imageBox.subviews{
            v.removeFromSuperview()
        }
        self.imageBox.removeConstraints(self.lastImageBoxConstraints)
    }
    
    func layoutImages() {
        
        
        if (self.post?.imageThumbnails.count ?? 0) > 0 {
            
            if self.post?.imageThumbnails.count == 1 {
                self.arrange1Image()
            }else if post?.imageThumbnails.count == 2 {
                self.arrange2Images()
            }else if self.post?.imageThumbnails.count == 3 {
                self.arrange3Images()
            }
            
            self.imageBoxHeight.constant = 180
        }else {
            self.imageBoxHeight.constant = 0
        }
    }
    
    //MARK - picture layout
    func arrange1Image() {
        
        let iv = UIImageView(image: self.post?.imageThumbnails.first)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.imageBox.addSubview(iv)
        let views: [String:Any] = ["iv": iv]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        self.imageBox.addConstraints(constraints)
        self.lastImageBoxConstraints = constraints
    }
    
    func arrange2Images() {
        
        let iv = UIImageView(image: self.post?.imageThumbnails[0])
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        let iv2 = UIImageView(image:self.post?.imageThumbnails[1])
        iv2.clipsToBounds = true
        iv2.contentMode = .scaleAspectFill
        iv2.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageBox.addSubview(iv)
        self.imageBox.addSubview(iv2)
        let views: [String:Any] = ["iv2": iv2, "iv": iv]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-[iv2(==iv)]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv2]-|", options: [], metrics: nil, views: views)
        self.imageBox.addConstraints(constraints)
        self.lastImageBoxConstraints = constraints
    }
    
    func arrange3Images() {
        
        let iv = UIImageView(image: self.post?.imageThumbnails[0])
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        let iv2 = UIImageView(image: self.post?.imageThumbnails[1])
        iv2.clipsToBounds = true
        iv2.contentMode = .scaleAspectFill
        iv2.translatesAutoresizingMaskIntoConstraints = false
        
        
        let iv3 = UIImageView(image: self.post?.imageThumbnails[2])
        iv3.clipsToBounds = true
        iv3.contentMode = .scaleAspectFill
        iv3.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageBox.addSubview(iv)
        self.imageBox.addSubview(iv2)
        self.imageBox.addSubview(iv3)
        let views: [String:Any] = ["iv2": iv2, "iv": iv, "iv3": iv3]
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-[iv2(==iv)]-|", options: [], metrics: nil, views: views)
        constraints += [NSLayoutConstraint(item: iv3, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: iv2, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: iv3, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: iv2, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)]
        
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv2]-[iv3(==iv2)]-|", options: [], metrics: nil, views: views)
        self.imageBox.addConstraints(constraints)
        self.lastImageBoxConstraints = constraints
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
