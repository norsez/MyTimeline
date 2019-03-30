//
//  TimelineCell.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAnimated
//MARK - view for timeline cell
class TimelineCell: UITableViewCell {
    
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var imageBox: UIView!
    @IBOutlet var imageBoxHeight: NSLayoutConstraint!
    
    var post: Post? = nil
    var lastImageBoxConstraints = [NSLayoutConstraint]()
    
    var image1 = Variable<UIImage?>(nil)
    var image2 = Variable<UIImage?>(nil)
    var image3 = Variable<UIImage?>(nil)
    let serialScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "cell image loading queue")
    let disposeBag = DisposeBag()
    
    
    func display(post: Post) {
        self.post = post
        self.bodyLabel.text = post.body
        self.timestampLabel.text = "\(post.timestamp.asTimelineTime) >"
        self.loadAndDisplayImages()
    }
    
    override func prepareForReuse() {
        self.bodyLabel.text = nil
        self.imageBoxHeight.constant = 0
        for v in self.imageBox.subviews{
            v.removeFromSuperview()
        }
        self.imageBox.removeConstraints(self.lastImageBoxConstraints)
    }
    
    func loadAndDisplayImages() {
        let imageCount = self.post?.imageDataFilenames.count ?? 0
        switch imageCount {
        case 0:
            self.imageBoxHeight.constant = 0
        case 1:
            self.arrange1Image()
            self.imageBoxHeight.constant = 180
        case 2:
            self.arrange2Images()
            self.imageBoxHeight.constant = 180
        case 3:
            self.arrange3Images()
            self.imageBoxHeight.constant = 180
        default:
            debugPrint("too many images to display. Skip \(imageCount - 3) images")
            break
        }
}
    
    //MARK - picture layout
    func arrange1Image() {
        
        let iv = crateImageView(for: 0, post: self.post!)
        
        self.imageBox.addSubview(iv)
        let views: [String:Any] = ["iv": iv]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iv]-|", options: [], metrics: nil, views: views)
        self.imageBox.addConstraints(constraints)
        self.lastImageBoxConstraints = constraints
    }
    
    func arrange2Images() {
        
        let iv = crateImageView(for: 0, post: self.post!)
        let iv2 = crateImageView(for: 1, post: self.post!)
        
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
        let iv = crateImageView(for: 0, post: self.post!)
        let iv2 = crateImageView(for: 1, post: self.post!)
        let iv3 = crateImageView(for: 2, post: self.post!)
        
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
    
    //MARK: image views
    func crateImageView(for imageIndex: Int, post: Post) -> UIImageView {
        let filename = post.imageDataFilenames[imageIndex]
        
        
        let iv = UIImageView(image: UIImage())
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let ivImage: Variable<UIImage?>
        switch imageIndex {
        case 0:
            ivImage = image1
        case 1:
            ivImage = image2
        default:
            ivImage = image3
        }
        
        ImageProvider.shared.loadImage(withFilename: filename)
            .observeOn(self.serialScheduler)
            .subscribe(onNext: { (maybeImage) in
                ivImage.value = maybeImage
            }).disposed(by: disposeBag)
            
        
       ivImage.asDriver().bind(animated: iv.rx.animated.fade(duration: 0.5).image)
            .disposed(by: disposeBag)
        return iv
    }
}
