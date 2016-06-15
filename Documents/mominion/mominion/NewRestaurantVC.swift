//
//  FoodVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/14/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

let Message_SubmitProductDS_ActionSheet_Title = "Lấy hình ảnh từ:"
let Message_SubmitProductDS_ActionSheet_CameraRoll = "Thư viện ảnh"
let Message_SubmitProductDS_ActionSheet_Capture = "Chụp ảnh"

class NewRestaurantVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var resInformationtbv: UITableView!
    var inputingField: Int = -1
    var restaurant = Restaurant()
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resInformationtbv.delegate = self
        resInformationtbv.dataSource = self
        self.resInformationtbv!.rowHeight = UITableViewAutomaticDimension
        self.resInformationtbv!.estimatedRowHeight = 296.0
        
        self.imagePicker.delegate = self
        triggerEvent()
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.restaurant.photo = image
            self.resInformationtbv.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewRestaurantVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        switch indexPath.row {
        case 0:
            return createAndConfigureCellRestaurantName()
        case 1:
            return createAndConfigureCellPhoto()
        case 2:
            return createAndConfigureCellOpenTime()
        case 3:
            return createAndConfigureCellAddress()
        case 4:
            return createAndConfigureCellSpecifi()
        case 5:
            return createAndConfigureCellPriceRange()
        default:
            return UITableViewCell()
        }
    }

    func createAndConfigureCellRestaurantName() -> CellOneLabel {
        let cellTitle = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.restaurant.name?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.restaurant.name
        } else {
            cellTitle.cellOneLabel.text = "Restaurant name"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellOpenTime() -> CellOpenTime {
        let cellTitle = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellOpenTime") as! CellOpenTime
        
        if self.restaurant.openTime?.characters.count > 0 {
            cellTitle.lblOpenTime.text = self.restaurant.openTime
        } else {
            cellTitle.lblOpenTime.text = "Open Time"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellAddress() -> CellOneLabel {
        let cellTitle = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.restaurant.address?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.restaurant.address
        } else {
            cellTitle.cellOneLabel.text = "Address"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellSpecifi() -> CellOneLabel {
        let cellTitle = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.restaurant.specifi?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.restaurant.specifi
        } else {
            cellTitle.cellOneLabel.text = "Specifi"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellPriceRange() -> CellPriceRange {
        let cellTitle = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellPriceRange") as! CellPriceRange
        
        if self.restaurant.priceRange?.characters.count > 0 {
            cellTitle.lblPriceRange.text = self.restaurant.priceRange
        } else {
            cellTitle.lblPriceRange.text = "Price Range"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellPhoto() -> CellRestaurantPhoto {
        let cellPhoto = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellRestaurantPhoto") as! CellRestaurantPhoto
        if let photo = self.restaurant.photo {
            cellPhoto.photo.image = photo.resizeImage(500)
        }
        
        return cellPhoto
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        startEditField(at: indexPath.row)
    }
    
    func startEditField(at index:Int) {
        switch index {
        case 0:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.name, forKey: K_Inputed_Text)
        case 1:
            showActionSheet(index)
            return
        case 2:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.openTime, forKey: K_Inputed_Text)
        case 3:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.address, forKey: K_Inputed_Text)
        case 4:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.specifi, forKey: K_Inputed_Text)
        case 5:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.priceRange, forKey: K_Inputed_Text)
        default:
            break
        }
        
        self.inputingField = index
        NSUserDefaults.standardUserDefaults().synchronize()
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.performSegueWithIdentifier(SegK_TextInputVC, sender: nil)
        }
    }
    
    func triggerEvent() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewRestaurantVC.didInputProcessingField(_:)), name: EK_TextInputVC_did_input, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: "didSelectedPhotos:",
//            name: EK_PhotoSelectionVC_selected_photo,
//            object: nil)
    }
    
    func didInputProcessingField(notification: NSNotification) {
        switch self.inputingField {
        case 0:
            self.restaurant.name = notification.userInfo![K_Inputed_Text] as? String
        case 1:
            break
        case 2:
            self.restaurant.openTime = notification.userInfo![K_Inputed_Text] as? String
        case 3:
            self.restaurant.address = notification.userInfo![K_Inputed_Text] as? String
        case 4:
            self.restaurant.specifi = notification.userInfo![K_Inputed_Text] as? String
        case 5:
            self.restaurant.priceRange = notification.userInfo![K_Inputed_Text] as? String
        default:
            break
        }
        self.resInformationtbv.reloadData()
        self.inputingField = -1
    }
}

