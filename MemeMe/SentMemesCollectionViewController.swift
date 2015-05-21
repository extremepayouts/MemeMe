//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Joe White on 5/14/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    // Collection View Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let theMeme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.memeImage?.image = theMeme.memeImage
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        
        let theMeme = self.memes[indexPath.row]
        
        //set uiimage view with meme selectged
        detailController.myMeme = theMeme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Sent Memes"
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createMeme")
        self.navigationItem.rightBarButtonItem = button
    }
    
    func createMeme() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}