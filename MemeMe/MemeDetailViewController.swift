//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Joe White on 5/20/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var detailMemeImage: UIImageView!
    
    var myMeme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailMemeImage.image = myMeme.memeImage
    }
    
}