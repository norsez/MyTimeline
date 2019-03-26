//
//  TimelineCell.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
//MARK - view for timeline cell
class TimelineCell: UITableViewCell {
    
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
    func set(post: Post) {
        self.bodyLabel.text = post.body
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        self.timestampLabel.text = df.string(from: post.timestamp)
        
        if post.imageDataFilename.count > 0 && post.imageThumbnails.count == 0 {
            //cache thumbnails on post model.
            post.loadThumbnails()
        }
        
        if post.imageThumbnails.count > 0 {
            
            self.imageView1.image = post.imageThumbnails.first!
            
            
            if post.imageThumbnails.count > 1 {
                self.imageView2.image = post.imageThumbnails[1]
            }
            
            if post.imageThumbnails.count > 2 {
                self.imageView3.image = post.imageThumbnails[2]
            }
        }
    }
    
    override func prepareForReuse() {
        self.bodyLabel.text = nil
        self.imageView1.image = nil
        self.imageView2.image = nil
        self.imageView3.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

