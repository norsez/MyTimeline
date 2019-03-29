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
    var postViewModels = [PostTimelineViewModel]()
    var searchResult = [PostTimelineViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        
        //reload when items are changed.
        self.items.asObservable()
            .subscribe(onNext: { [weak self] (posts) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
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
            self.postViewModels = self.items.value.compactMap({ (post) -> PostTimelineViewModel? in
                return PostTimelineViewModel(with: post)
            })
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
        
        let postViewModel: PostTimelineViewModel
        if isFiltering(){
            postViewModel = self.searchResult[indexPath.row]
        }else {
            postViewModel = self.postViewModels[indexPath.row]
        }
        
        postViewModel.configure(view: cell)
        
        return cell
    }
    
    //MARK - action for a new post created.
    func onDidCreateNewPost (_ post: Post) {
        
        var updatedItems = self.items.value
        updatedItems.insert(post, at: 0)
        self.items.accept(updatedItems)
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        
    }
    
    //MARK - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "See Post" {
            if let ctrl = segue.destination as? PostViewController,
                let index = tableView.indexPathForSelectedRow {
                
                let post = self.items.value[index.row]
                ctrl.post = post
            }
        }else if segue.identifier == "Compose" {
            if let ctrl = segue.destination as? ComposeViewController {
                ctrl.viewModel.newPostCreated.asObservable().subscribe(onNext: { (post) in
                    if let post = post {
                        self.onDidCreateNewPost(post)
                    }
                }).disposed(by: disposeBag)
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
        }).compactMap({ (post) -> PostTimelineViewModel? in
            return PostTimelineViewModel(with: post)
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
