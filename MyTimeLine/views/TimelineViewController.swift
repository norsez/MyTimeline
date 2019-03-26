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
    let searchController = UISearchController(searchResultsController: nil)
    var disposeBag = DisposeBag()
    var items = BehaviorRelay<[Post]>(value:[])
    var searchResult = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        
        //reload when items are changed.
        self.items.asObservable()
            .subscribe(onNext: { [weak self] (posts) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        //listen for newly an added post
        NotificationCenter.default.addObserver(self, selector: #selector(onDidCreateNewPost(_:)), name: Notification.Name.DataDidCreateNewPost, object: nil)
        
        
        
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    
    //MARK - table view datasource delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return self.searchResult.count
        }else {
            return self.items.value.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELLID , for: indexPath) as! TimelineCell
        
        let post: Post
        if isFiltering(){
            post = self.searchResult[indexPath.row]
        }else {
            post = self.items.value[indexPath.row]
        }
        
        cell.set(post: post)
        
        return cell
    }
    
    //MARK - listen for new post created.
    @objc func onDidCreateNewPost (_ notification: Notification) {
        if let post = notification.userInfo?["post"] as? Post {
            var updatedItems = self.items.value
            updatedItems.insert(post, at: 0)
            self.items.accept(updatedItems)
        }
    }
    
    //MARK - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "See Post" {
            if let ctrl = segue.destination as? PostViewController,
                let index = tableView.indexPathForSelectedRow {
                
                let post = self.items.value[index.row]
                ctrl.post = post
            }
        }
    }
    
}
//MARK - search
extension TimelineViewController: UISearchResultsUpdating {
    
    func isFiltering() -> Bool {
        return self.searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.searchResult = self.items.value.filter({( post : Post) -> Bool in
            return post.body?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        tableView.reloadData()
    }
    func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
