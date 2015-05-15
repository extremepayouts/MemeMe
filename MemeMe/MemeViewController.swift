//
//  ViewController.swift
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

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.attributedPlaceholder = NSAttributedString(string:"TOP",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        self.bottomTextField.attributedPlaceholder = NSAttributedString(string:"BOTTOM",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        self.topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
 
    func save() {
        //Create the meme
        let memeImage = generateMemedImage()
        var meme = Meme( textFieldTop: topTextField.text!, textFieldBottom: bottomTextField.text!, image: imagePickerView.image!, memeImage: memeImage)
    }
 
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        
        return memedImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        textField.placeholder = nil;
    }
    
    //dismiss the keyboard when return key selected
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.topTextField.textAlignment = .Center
        self.bottomTextField.textAlignment = .Center
        
        self.view.endEditing(true)
        return false
    }
}

