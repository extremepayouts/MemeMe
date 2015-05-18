//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Joe White on 5/14/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDataSource {

    var memes: [Meme]!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme")
        self.navigationItem.rightBarButtonItem = button
    }
    
    func createMeme() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "memeCell")
        let theMeme = self.memes[indexPath.row]
        
        cell.textLabel?.text = theMeme.textFieldTop! + "..." + theMeme.textFieldBottom!
        cell.imageView?.image = theMeme.image
        
        return cell
    }
}