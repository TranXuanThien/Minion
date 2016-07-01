//
//  ThumbnailBar.swift
//  Sopi
//
//  Created by Nguyen Thanh Liem on 2/20/16.
//  Copyright © 2016 DareWolk. All rights reserved.
//

import UIKit

let ThumbnailBorderColor = UIColor(red: CGFloat(0x00)/255
    ,green: CGFloat(0x83)/255
    ,blue: CGFloat(0xff)/255
    ,alpha: 1.0)

protocol ThumbnailBarDelegate {
    func thumbnailBarDelegate(AddPhoto photo: UIImage)
    func thumbnailBarDelegate(SelectedPhotoAtIndex index: Int)
}

protocol ThumbnailBarDataSource {
    var photos:[UIImage] {get set}
    var selectedPhoto: Int {set get}
}

class ThumbnailBar: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate  {
    let imagePicker = UIImagePickerController()
    
    var delegate: ThumbnailBarDelegate?
    var datasource: ThumbnailBarDataSource?
    
    var ownerViewController: UIViewController?
    
    @IBOutlet weak var imvThumbnail1: UIImageView!
    @IBOutlet weak var imvThumbnail2: UIImageView!
    @IBOutlet weak var imvThumbnail3: UIImageView!
    @IBOutlet weak var imvThumbnail4: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePicker.delegate = self
        
        let photoViewArray:[UIImageView] = [imvThumbnail1, imvThumbnail2, imvThumbnail3, imvThumbnail4]
        for photoView in photoViewArray {
            let recognizer = UITapGestureRecognizer(target: self, action:Selector("handlePhotoTap:"))
            recognizer.delegate = self
            photoView.userInteractionEnabled = true
            photoView.addGestureRecognizer(recognizer)
        }
    }
    
    func handlePhotoTap(recognizer: UITapGestureRecognizer) {
        if recognizer.view?.tag > datasource?.photos.count {
            showActionSheet(recognizer.view!)
        }else{
            if let view = recognizer.view {
                datasource?.selectedPhoto = view.tag
                selectPhotoAtIndex(view.tag)
                delegate?.thumbnailBarDelegate(SelectedPhotoAtIndex: view.tag)
            }
        }
    }
    
    func selectPhotoAtIndex(index: Int) {
        let photoViewArray:[UIImageView] = [imvThumbnail1, imvThumbnail2, imvThumbnail3, imvThumbnail4]
        for view in photoViewArray {
            if view.tag == index {
                view.layer.borderColor = ThumbnailBorderColor.CGColor
                view.layer.borderWidth = 2
            }else {
                view.layer.borderColor = UIColor.clearColor().CGColor
                view.layer.borderWidth = 0
            }
        }
    }
    
    func showCurrentState() {
        showPhoto((self.datasource?.photos)!)
        selectPhotoAtIndex((self.datasource?.selectedPhoto)!)
    }
    
    func showPhoto(photos: [UIImage]){
        switch photos.count {
        case 0:
            imvThumbnail1.image = UIImage(named: "ico_camera_gray")
            imvThumbnail2.hidden = true
            imvThumbnail3.hidden = true
            imvThumbnail4.hidden = true
        case 1:
            imvThumbnail1.image = photos[0]
            imvThumbnail2.hidden = false
            imvThumbnail2.image = UIImage(named: "ico_camera_gray")
            imvThumbnail3.hidden = true
            imvThumbnail4.hidden = true
        case 2:
            imvThumbnail1.image = photos[0]
            imvThumbnail2.image = photos[1]
            imvThumbnail2.hidden = false
            imvThumbnail3.image = UIImage(named: "ico_camera_gray")
            imvThumbnail3.hidden = false
            imvThumbnail4.hidden = true
        case 3:
            imvThumbnail1.image = photos[0]
            imvThumbnail1.hidden = false
            imvThumbnail2.image = photos[1]
            imvThumbnail2.hidden = false
            imvThumbnail3.image = photos[2]
            imvThumbnail3.hidden = false
            imvThumbnail4.image = UIImage(named: "ico_camera_gray")
            imvThumbnail4.hidden = false
        case 4:
            imvThumbnail1.image = photos[0]
            imvThumbnail1.hidden = false
            imvThumbnail2.image = photos[1]
            imvThumbnail2.hidden = false
            imvThumbnail3.image = photos[2]
            imvThumbnail3.hidden = false
            imvThumbnail4.image = photos[3]
            imvThumbnail4.hidden = false
        default:
            imvThumbnail1.image = UIImage(named: "ico_camera_gray")
            imvThumbnail2.hidden = true
            imvThumbnail3.hidden = true
            imvThumbnail4.hidden = true
        }
    }
    
    func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: Message_SubmitProductDS_ActionSheet_Title, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: Message_SubmitProductDS_ActionSheet_CameraRoll, style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.ownerViewController?.presentViewController(self.imagePicker, animated: true, completion: nil)
            print("Choose photo from cameraroll")
        })
        let saveAction = UIAlertAction(title: Message_SubmitProductDS_ActionSheet_Capture, style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
            self.ownerViewController?.presentViewController(self.imagePicker, animated: true, completion: nil)
            print("Choose photo when capture")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Choose photo: Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.ownerViewController?.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.ownerViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.ownerViewController?.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.delegate?.thumbnailBarDelegate(AddPhoto: image.resizeImage(800))
        }
    }
}
