//
//  Utils.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit


//MARK: quick and dirty way to generate hash
extension String {
    static func randomString(withLength len: Int) -> String {
        let LETTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var result = ""
        for _ in 0..<len {
            let s = String(LETTERS.randomElement() ?? "-")
            result = "\(result)\(s)"
        }
        return result
    }
}

//MARK - id util
extension UIImage {
    func randomFilename() -> String {
        return String.randomString(withLength: 16)
    }
}


//MARK: read write image on disk
extension UIImage {
    func saveOnDisk() throws -> URL? {
        
        let fm = FileManager.default
        var fileUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        fileUrl.appendPathComponent(self.randomFilename())
        let data = self.pngData()
        try data?.write(to: fileUrl)
        
        return fileUrl
    }
}
