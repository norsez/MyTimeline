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
    @IBOutlet var imageBox: UIView!
    @IBOutlet var imageBoxHeight: NSLayoutConstraint!
    
    @IBOutlet var contraintImage1Height: NSLayoutConstraint!
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
            
           
            self.imageBoxHeight.constant = 180
        }else {
            self.imageBoxHeight.constant = 0
        }
    }
    
    override func prepareForReuse() {
        self.bodyLabel.text = nil
        
    }
    
}

