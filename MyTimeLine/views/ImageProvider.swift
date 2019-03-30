//
//  ImageProvider.swift
//  MyTimeLine
//
//  Created by norsez on 30/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageProvider {
    static let shared = ImageProvider()
    private init() {}
    
    let imageCache = NSCache<NSString,UIImage>()
    
    //MAKR: reactive version of loading an image
    func loadImage(withFilename filename: String) -> Observable<UIImage?> {
        return Observable.create {
            observer in
            
            if let cachedImage = self.imageCache.object(forKey: filename as NSString) {
                observer.onNext(cachedImage)
                observer.onCompleted()
                return Disposables.create()
            }
            
            
            let image = UIImage.loadImage(withPostImagefilename: filename)
            
            if let img = image {
                self.imageCache.setObject(img, forKey: filename as NSString)
            }
            
            observer.onNext(image)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
