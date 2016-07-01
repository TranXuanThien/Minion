//
//  BaseVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/20/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        self.imagePicker.delegate = self
    }
    
    func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: Message_SubmitProductDS_ActionSheet_Title, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: Message_SubmitProductDS_ActionSheet_CameraRoll, style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            print("Choose photo from cameraroll")
        })
        let saveAction = UIAlertAction(title: Message_SubmitProductDS_ActionSheet_Capture, style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            print("Choose photo when capture")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Choose photo: Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if self.isKindOfClass(NewRestaurantVC) {
               NSNotificationCenter.defaultCenter().postNotificationName("imageRestaurant", object: image)
            }
            
            if self.isKindOfClass(NewFoodVC) {
                NSNotificationCenter.defaultCenter().postNotificationName("imageFood", object: image)
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
