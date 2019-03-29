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
class TimelineCell: UITableViewCell, PostTimelineView {
    
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var imageBox: UIView!
    @IBOutlet var imageBoxHeight: NSLayoutConstraint!
    
    var post: Post? = nil
    
    override func prepareForReuse() {
        self.bodyLabel.text = nil
        self.imageBoxHeight.constant = 0
        for v in self.imageBox.subviews{
            v.removeFromSuperview()
        }
    }
    
}
