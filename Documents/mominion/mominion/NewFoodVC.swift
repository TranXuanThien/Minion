//
//  NewFoodVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/16/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class NewFoodVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tbvNewFood: UITableView!
    var food = Food()
    let imagePicker = UIImagePickerController()
    var inputingField: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvNewFood.delegate = self
        tbvNewFood.dataSource = self
        self.tbvNewFood!.rowHeight = UITableViewAutomaticDimension
        self.tbvNewFood!.estimatedRowHeight = 296.0
        
        self.imagePicker.delegate = self
        triggerEvent()
    }
    
    func triggerEvent() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.didInputProcessingField(_:)), name: EK_TextInputVC_did_input, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.didInputWifi(_:)), name: "inputWifi", object: nil)
        
        //        NSNotificationCenter.defaultCenter().addObserver(
        //            self,
        //            selector: "didSelectedPhotos:",
        //            name: EK_PhotoSelectionVC_selected_photo,
        //            object: nil)
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
            self.food.photo = image
            self.tbvNewFood.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NewFoodVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return createAndConfigureCellPhoto()
        case 1:
            return createAndConfigureCellName()
        case 2:
            return createAndConfigureCellSubName()
        case 3:
            return createAndConfigureCellPrice()
        case 4:
            return createAndConfigureCellCateID()
        case 5:
            return createAndConfigureCellKindOfMeal()
        case 6:
            return createAndConfigureCellMealTime()
        case 7:
            return createAndConfigureCellSpecific()
        case 8:
            return createAndConfigureCellDescription()
        case 9:
            return createAndConfigureCellDrink()
        default:
            return UITableViewCell()
        }
    }
    
    func createAndConfigureCellName() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.name?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.name
        } else {
            cellTitle.cellOneLabel.text = "food name"
        }
        
        return cellTitle
    }
    func createAndConfigureCellSubName() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.subName?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.subName
        } else {
            cellTitle.cellOneLabel.text = "Sub name"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellPrice() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.price?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.price
        } else {
            cellTitle.cellOneLabel.text = "Price"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellCateID() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.cateID?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.cateID
        } else {
            cellTitle.cellOneLabel.text = "Category ID"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellKindOfMeal() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.kindOfMeal?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.kindOfMeal
        } else {
            cellTitle.cellOneLabel.text = "Kind of meal"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellMealTime() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.mealTime?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.mealTime
        } else {
            cellTitle.cellOneLabel.text = "Meal time"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellSpecific() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.specific?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.specific
        } else {
            cellTitle.cellOneLabel.text = "Specific"
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellDescription() -> CellOneLabel {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellOneLabel") as! CellOneLabel
        
        if self.food.descriptionFood?.characters.count > 0 {
            cellTitle.cellOneLabel.text = self.food.descriptionFood
        } else {
            cellTitle.cellOneLabel.text = "Description"
        }
        
        return cellTitle
    }
    
    
    func createAndConfigureCellDrink() -> CellWifi {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellWifi") as! CellWifi
        
        if self.food.isDrink == true {
            cellTitle.btnYes.tintColor = UIColor.redColor()
        } else {
            cellTitle.btnYes.tintColor = UIColor.redColor()
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellPhoto() -> CellRestaurantPhoto {
        let cellPhoto = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellRestaurantPhoto") as! CellRestaurantPhoto
        if let photo = self.food.photo {
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
            showActionSheet(index)
            return
        case 1:
            NSUserDefaults.standardUserDefaults().setObject(self.food.name, forKey: K_Inputed_Text)
        case 2:
            NSUserDefaults.standardUserDefaults().setObject(self.food.subName, forKey: K_Inputed_Text)
        case 3:
            NSUserDefaults.standardUserDefaults().setObject(self.food.price, forKey: K_Inputed_Text)
        case 4:
            let cateVC = CategoryVC()
            self.navigationController?.pushViewController(cateVC, animated: true)
            return
        case 5:
            NSUserDefaults.standardUserDefaults().setObject(self.food.kindOfMeal, forKey: K_Inputed_Text)
        case 6:
            NSUserDefaults.standardUserDefaults().setObject(self.food.mealTime, forKey: K_Inputed_Text)
        case 7:
            NSUserDefaults.standardUserDefaults().setObject(self.food.specific, forKey: K_Inputed_Text)
        case 8:
            NSUserDefaults.standardUserDefaults().setObject(self.food.descriptionFood, forKey: K_Inputed_Text)
        default:
            break
        }
        
        self.inputingField = index
        NSUserDefaults.standardUserDefaults().synchronize()
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.performSegueWithIdentifier(SegK_TextInputVC, sender: nil)
        }
    }

    func didInputProcessingField(notification: NSNotification) {
        switch self.inputingField {
        case 0:
            break
        case 1:
            self.food.name = notification.userInfo![K_Inputed_Text] as? String
        case 2:
            self.food.subName = notification.userInfo![K_Inputed_Text] as? String
        case 3:
            self.food.price = notification.userInfo![K_Inputed_Text] as? String
        case 4:
            self.food.cateID = notification.userInfo![K_Inputed_Text] as? String
        case 5:
            self.food.kindOfMeal = notification.userInfo![K_Inputed_Text] as? String
        case 6:
            self.food.mealTime = notification.userInfo![K_Inputed_Text] as? String
        case 7:
            self.food.specific = notification.userInfo![K_Inputed_Text] as? String
        case 8:
            self.food.descriptionFood = notification.userInfo![K_Inputed_Text] as? String
        default:
            break
        }
        self.tbvNewFood.reloadData()
        self.inputingField = -1
    }
    
    func didInputWifi(notification: NSNotification) {
        let isHaveDrink = notification.object as? Bool
        self.food.isDrink = isHaveDrink
    }
    
}

