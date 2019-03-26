//
//  File.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
//MARK - view for a post
class PostViewController: UITableViewController {
    
    enum Section: Int {
        case body, image
        static let ALL:[Section] = [.body, .image]
    }
    
    let CELL_BODY = "BodyCell"
    let CELL_IMAGE = "ImageCell"
    var post: Post? = nil
    
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
            return self.post?.imageThumbnails.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .body:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_BODY, for: indexPath) as! PostBodyCell
            cell.postBodyLabel.text = self.post?.body
            cell.postTimeLabel.text = self.post?.timestamp.asTimelineTime
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_IMAGE, for: indexPath) as! PostImageCell
            let image = self.post?.imageThumbnails[indexPath.row]
            cell.postImageView.image = image
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "See Photo" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let section = Section(rawValue: indexPath.section)!
                switch  section {
                case .image:
                    let ctrl = segue.destination as! PhotoViewController
                    ctrl.imageToShow = self.post?.imageThumbnails[indexPath.row]
                default:
                    //do nothing
                    break
                }
            }
        }
    }
    
}
