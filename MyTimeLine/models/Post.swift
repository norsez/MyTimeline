//
//  Post.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RealmSwift
//MARK - model class for posts
final class Post: Object {
    @objc dynamic var timestamp = Date()
    @objc dynamic var body: String?
    let imageURLString = List<String>()
}

