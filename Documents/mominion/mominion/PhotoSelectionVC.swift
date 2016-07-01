//
//  PhotoSelectionVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/27/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

let SegK_PhotoSelection = "goToPhotoSelectionVC"

let EK_PhotoSelectionVC_selected_photo = "EK_PhotoSelectionVC_selected_photo"

let K_Selected_Photos = "K_Selected_Photos"

class PhotoSelectionVC: UIViewController, ThumbnailBarDelegate, ThumbnailBarDataSource {
    
    @IBOutlet weak var imvMainPhoto: UIImageView!
    @IBOutlet weak var thumbnailBar: ThumbnailBar!
    
    var photos: [UIImage] = []
    var selectedPhoto: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        thumbnailBar.delegate = self
        thumbnailBar.datasource = self
        thumbnailBar.ownerViewController = self
        
        showCurrentState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showCurrentState() {
        showCurrentPhoto()
        thumbnailBar.showCurrentState()
    }
    
    func showCurrentPhoto() {
        if selectedPhoto > photos.count {
            imvMainPhoto.image = nil
            return
        }
        imvMainPhoto.image = photos[selectedPhoto-1]
    }
    
    @IBAction func setPhotosRes(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(EK_PhotoSelectionVC_selected_photo, object: nil, userInfo: [K_Selected_Photos: photos])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deletePhotoRes(sender: AnyObject) {
        photos.removeAtIndex(selectedPhoto-1)
        selectedPhoto = 1
        showCurrentState()
    }
    
    func addPhoto(photo:UIImage) {
        if self.photos.count >= 4 {
            return
        }
        photos.append(photo)
    }
    
    func thumbnailBarDelegate(AddPhoto photo: UIImage) {
        addPhoto(photo)
        selectedPhoto = photos.count
    }
    
    func thumbnailBarDelegate(SelectedPhotoAtIndex index: Int) {
        imvMainPhoto.image = photos[index-1]
    }
    
    func photoSelectionTopBarDelegateClickBack() {
        NSNotificationCenter.defaultCenter().postNotificationName(EK_PhotoSelectionVC_selected_photo, object: nil, userInfo: [K_Selected_Photos: photos])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
