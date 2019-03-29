//
//  TimelineViewModel.swift
//  MyTimeLine
//
//  Created by norsez on 29/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class TimelineViewModel {
    
    var posts = [Post]()
    var searchResults = [Post]()
    
    var errorMessage = Variable<String?>(nil)
    var viewNeedsRefresh = Variable<Bool>(false)
    
    func loadPosts () {
        
        do {
            let realm = RealmProvider.realm()
            let results = realm.objects(Post.self).sorted { (p1, p2) -> Bool in
                return p1.timestamp.compare(p2.timestamp) == ComparisonResult.orderedDescending
            }
            self.posts = Array(results.map({ (p) -> Post in
                return p
            }))
            self.viewNeedsRefresh.value = true
            
        }catch {
            self.errorMessage.value = "\(error)"
        }
    }
    
}
