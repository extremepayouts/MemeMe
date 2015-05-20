//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Joe White on 5/7/15.
//  Copyright (c) 2015 emandelsolutions. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var TopNavigationBar: UINavigationBar!
    @IBOutlet weak var BottomToolbar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2
    ];

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //meme data
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        //show the tab controller if memes are found
        if appDelegate.memes.count > 0 {
            var tabController: UITabBarController
            tabController = self.storyboard?.instantiateViewControllerWithIdentifier("memeTabView") as! UITabBarController
            self.presentViewController(tabController, animated: true, completion: nil)
        }
    
    }
    
    override func viewWillAppear(animated: Bool) {
        //style top and bottom text
        self.topTextField.attributedPlaceholder = NSAttributedString(string:"TOP",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        self.bottomTextField.attributedPlaceholder = NSAttributedString(string:"BOTTOM",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        self.topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.topTextField.defaultTextAttributes = memeTextAttributes
        
        self.bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        //enable camera button if it is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //Allow image picker from album
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Image picker from camera roll
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
 
    func save() {
        //Create the meme
        let memeImage = generateMemedImage()
        var meme = Meme( textFieldTop: self.topTextField.text, textFieldBottom: self.bottomTextField.text, image: imagePickerView.image!, memeImage: memeImage)

        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
 
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.TopNavigationBar.hidden = true
        self.BottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.TopNavigationBar.hidden = false
        self.BottomToolbar.hidden = false
        
        return memedImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil;
    }
    
    //dismiss the keyboard when return key selected
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.topTextField.textAlignment = .Center
        self.bottomTextField.textAlignment = .Center
        
        self.view.endEditing(true)
        return false
    }
    
    //Upon cancel of meme add show tab view controller
    @IBAction func cancelClick(sender: AnyObject) {
        var tabController: UITabBarController
        tabController = self.storyboard?.instantiateViewControllerWithIdentifier("memeTabView") as! UITabBarController
        self.presentViewController(tabController, animated: true, completion: nil)
    }
    
    //Show activity view controller and save meme and display tab view controller
    @IBAction func actionClick(sender: AnyObject) {
        let meme = self.generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()

            var tabController: UITabBarController
            tabController = self.storyboard?.instantiateViewControllerWithIdentifier("memeTabView") as! UITabBarController
            self.presentViewController(tabController, animated: true, completion: nil)
        }
        
        self.presentViewController(activityController, animated:true, completion:nil)
    }
}

