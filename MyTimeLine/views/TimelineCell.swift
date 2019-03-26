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
        
        if let us = post.imageURLString.first {
            self.imageView1.image = UIImage.loadImage(with: us )
        }
        
        if post.imageURLString.count > 1 {
            let us = post.imageURLString[1]
            self.imageView2.image = UIImage.loadImage(with: us )
        }
        
        if post.imageURLString.count > 2 {
            let us = post.imageURLString[2]
            self.imageView3.image = UIImage.loadImage(with: us )
        }
    }
}

