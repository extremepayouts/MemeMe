//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Joe White on 5/14/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UIViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme")
        self.navigationItem.rightBarButtonItem = button
    }
    
    func createMeme() {
        self.dismissViewControllerAnimated(true, completion: nil)
     }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
}