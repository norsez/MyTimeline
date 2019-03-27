//
//  SeedData.swift
//  MyTimeLine
//
//  Created by norsez on 27/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RealmSwift

//MARK - Seed data for app demo and testing
class SeedData {
    
    func dropDatabase () throws {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
        print("Empty database.")
    }
    
    func loadSeedData() throws -> (messages: [String], pic_counts: [Int]) {
        guard let url = Bundle.main.url(forResource: "seed_posts", withExtension: "plist") else {
            fatalError("can't find seed_posts.plist")
        }
        
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: nil) as! [String:Any]
        print("seed posts: \(plist)")
        
        guard let messages = plist["posts"] as? [String] else {
            fatalError("messages can't be found in seed data.")
        }
        
        guard let pic_counts = plist["pic_counts"] as? [Int] else {
            fatalError("pic_counts can't be found in seed data")
        }
        
        return (messages, pic_counts)
    }
    
    func loadImageNames() throws -> [String] {
        var imageNames = [String]()
        print("copying seed images to disk…")
        for i in 0...9 {
            if let url = Bundle.main.url(forResource: "\(i)", withExtension: "jpg") {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    let name = try image.saveOnDisk()
                    imageNames.append(name)
                }
            }
        }
        return imageNames
    }
    
    func makeSeedPosts(with seed: (messages: [String], pic_counts: [Int]), imageNames: [String]) -> [Post] {
        print("no. of seed \(imageNames.count) images.")
        var posts = [Post]()
        for i in 0..<seed.messages.count {
            let p = Post()
            p.body = seed.messages[i]
            for _ in 0..<seed.pic_counts[i] {
                p.imageDataFilenames.append(imageNames.shuffled().first!)
            }
            posts.append(p)
        }
        return posts
    }
    
    func resetAndSeed() throws {
        let seed = try self.loadSeedData()
        let imageNames = try self.loadImageNames()
        let posts = self.makeSeedPosts(with: seed, imageNames: imageNames)
        
        //add to database
        let realm = try Realm()
        try realm.write {
            posts.forEach({ (p) in
                realm.add(p)
            })
        }
    
        print("Done.")
    }
    private init(){}
    static let shared = SeedData()
}


