//
//  File.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import RxSwift
import RxCocoa
import RxAnimated
//MARK - view for a post
class PostViewController: UITableViewController {
    
    enum Section: Int {
        case body, image
        static let ALL:[Section] = [.body, .image]
        static func isImage(_ indexPath: IndexPath) -> Bool {
            let section = Section(rawValue: indexPath.section)!
            return section == .image
        }
    }
    
    let CELL_BODY = "BodyCell"
    let CELL_IMAGE = "ImageCell"
    var post: Post? = nil
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.ALL.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection s: Int) -> Int {
        
        let section = Section(rawValue: s)!
        switch section {
        case .body:
            return 1
        case .image:
            return self.post?.imageDataFilenames.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Section.isImage(indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_IMAGE, for: indexPath) as! PostImageCell

            let imageFilename = self.post?.imageDataFilenames[indexPath.row] ?? ""
            ImageProvider.shared.loadImage(withFilename: imageFilename)
                .bind(animated: cell.postImageView.rx.image )
                .disposed(by: self.disposeBag)
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_BODY, for: indexPath) as! PostBodyCell
        cell.postBodyLabel.text = self.post?.body
        cell.postTimeLabel.text = self.post?.timestamp.asTimelineTime
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Section.isImage(indexPath) {
            showPhoto(at: indexPath)
        }
    }
    
}

//MARK: show photo viewer
extension PostViewController {
    func showPhoto(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PostImageCell
        let originImage = cell.imageView?.image ?? UIImage()
        
        var filenames = [String]()
        self.post!.imageDataFilenames.forEach { (s) in
            filenames.append(s)
        }
        
        let photos =  filenames.map { (filename) -> SKPhoto in
            let image = ImageProvider.shared.imageCache.object(forKey: filename as NSString)
            return SKPhoto.photoWithImage(image ?? UIImage())
        }
        
        let browser = SKPhotoBrowser(originImage: originImage, photos: photos , animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)
        self.present(browser, animated: true, completion: nil)
    }
}
