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
    
    var isTrimmedEmpty: Bool {
        get {
            return self.trimmingCharacters(in: CharacterSet(charactersIn: " \t\n\r")).count == 0
        }
    }
    
    var asFileUrl: URL? {
        get {
            return URL(fileURLWithPath: self)
        }
    }
}

//MARK - Date util
extension Date {
    var asTimelineTime: String {
        get{
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"
            return df.string(from: self)
        }
    }
}

//MARK - view controller util
extension UIViewController {
    func alert(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    //save self on disk
    //@retrun url to the Data file
    func saveOnDisk() throws -> String {
        
        let fm = FileManager.default
        var fileUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filename = self.randomFilename()
        fileUrl.appendPathComponent(filename)
        let data = self.pngData()
        try data?.write(to: fileUrl)
        return filename
    }
    
    //load image data as a UIImage
    //@return UIImage or nil
    static func loadImage(with filename: String) -> UIImage? {
        
        let fm = FileManager.default
        
        do {
            var fileUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            fileUrl.appendPathComponent(filename)
            
            let data = try Data(contentsOf: fileUrl)
            let image = UIImage(data: data)
            return image
        }catch {
            debugPrint(error)
            return nil
        }
    }
}
