//
//  TimelineViewController.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

//MARK - view for timeline
class TimelineViewController: UITableViewController {
    let CELLID = "TimelineCell"
    var disposeBag = DisposeBag()
    var items = BehaviorRelay<[Post]>(value:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reload when items are changed.
        self.items.asObservable()
            .subscribe(onNext: { [weak self] (posts) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
//        //table view reloads when items are changed.
//        self.items.asObservable()
//            .bind(to: tableView.rx.items) {
//               (tableView, index, post) in
//                let indexPath = IndexPath(item: index, section:0)
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as? TimelineCell {
//                    cell.set(post: post)
//                    return cell
//                }
//
//                return UITableViewCell()
//        }.disposed(by: disposeBag)
        
        
        
        //load database
        do {
            let realm = try Realm()
            let results = realm.objects(Post.self).sorted { (p1, p2) -> Bool in
                return p1.timestamp.compare(p2.timestamp) == ComparisonResult.orderedDescending
            }
            let posts = Array(results.map({ (p) -> Post in
                return p
            }))
            self.items.accept(posts)
        }catch {
            self.alert(error: error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELLID , for: indexPath) as! TimelineCell
        
        let post = self.items.value[indexPath.row]
        cell.set(post: post)
        
        return cell
    }
}
