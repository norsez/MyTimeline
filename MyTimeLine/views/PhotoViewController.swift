//
//  PhotoViewController.swift
//  MyTimeLine
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import UIKit
class PhotoViewController: UIViewController {
    @IBOutlet var photoView: UIImageView!
    var imageToShow: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissThis))
        self.view.addGestureRecognizer(tap)
        
        self.photoView.image = self.imageToShow
    }
    
    @objc func dismissThis() {
        self.dismiss(animated: true, completion: nil)
    }
}
