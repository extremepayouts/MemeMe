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
        
        //set cell row height
        self.tableView.rowHeight = 100.0
        
        //Add the plus button to call the createMeme function
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme")
        self.navigationItem.rightBarButtonItem = button
    }
    
    func createMeme() {
        //show the MemeViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //determine number of rows
        return self.memes.count
    }
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "memeCell")
    
        let theMeme = self.memes[indexPath.row]
        
        //set the table cell with meme image and text
        cell.textLabel?.text = theMeme.textFieldTop! + "..." + theMeme.textFieldBottom!
        cell.imageView?.image = theMeme.image
        
        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //create instance of detailController to display meme when it is clicked on
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        
        let theMeme = self.memes[indexPath.row]
        
        //set uiimage view with meme selectged
        detailController.myMeme = theMeme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}