//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Joe White on 5/14/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme")
        self.navigationItem.rightBarButtonItem = button
    }
    
    func createMeme() {
        let MemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
        navigationController?.pushViewController(MemeViewController, animated: true)
    }
    
}