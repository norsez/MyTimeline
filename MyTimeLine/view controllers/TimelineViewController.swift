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
    let viewModel = TimelineViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        bindViewToViewModel()
        createCallback()
        self.viewModel.loadPosts()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    
    //MARK - table view datasource delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return self.viewModel.searchResults.count
        }else {
            return self.viewModel.posts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELLID , for: indexPath) as! TimelineCell
        
        let post: Post
        if isFiltering(){
            post = self.viewModel.searchResults[indexPath.row]
        }else {
            post = self.viewModel.posts[indexPath.row]
        }
        
        cell.display(post: post)
        
        return cell
    }
    
    //MARK - action for a new post created.
    func onDidCreateNewPost (_ post: Post) {
        var updatedItems = self.viewModel.posts
        updatedItems.insert(post, at: 0)
        self.viewModel.posts = updatedItems
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    //MARK - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "See Post" {
            if let ctrl = segue.destination as? PostViewController,
                let index = tableView.indexPathForSelectedRow {
                
                let post: Post
                if isFiltering() {
                    post = self.viewModel.searchResults[index.row]
                }else {
                    post = self.viewModel.posts[index.row]
                }
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
        self.viewModel.searchResults = self.viewModel.posts.filter({( post : Post) -> Bool in
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
    
    //MARK: Rx binding
    func createCallback() {
        self.viewModel.errorMessage.asObservable()
            .bind { [weak self] msg in
                if let msg = msg {
                    self?.alert(message: msg)
                }
            }.disposed(by: disposeBag)
        
        self.viewModel.viewNeedsRefresh.asObservable()
            .bind { [weak self]
                needs in
                if needs {
                    self?.tableView.reloadData()
                }
            }.disposed(by: disposeBag)
        
    }
    
    func bindViewToViewModel () {
        //do nothing
    }
    
}
