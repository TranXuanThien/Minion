//
//  NewFoodVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/16/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

let clouder = CLCloudinary(url: "cloudinary://869393512314214:7Py8LZXCU3onzqEvq90KY5Nm2yY@drbathp1m")

class NewFoodVC: BaseVC, CLUploaderDelegate {
    @IBOutlet weak var tbvNewFood: UITableView!
    var food = Food()
    var inputingField: Int = -1
    var photo:UIImage?
    var activityIndicator:UIView?
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvNewFood.delegate = self
        tbvNewFood.dataSource = self
        self.tbvNewFood!.rowHeight = UITableViewAutomaticDimension
        self.tbvNewFood!.estimatedRowHeight = 296.0
        
        triggerEvent()
        self.food.photoURL = [String]()
    }
    
    func triggerEvent() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.didInputProcessingField(_:)), name: EK_TextInputVC_did_input, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.didInputWifi(_:)), name: "inputWifi", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.setKindOfMeal(_:)), name: "inputKindOfMeal", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.didChooseCategory(_:)), name: "chooseCategory", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewFoodVC.didChooseMealTime(_:)), name: "chooseMealTime", object: nil)

        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectedPhotos:",
            name: EK_PhotoSelectionVC_selected_photo,
            object: nil)
    }

    override func showActionSheet(sender: AnyObject) {
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
    
    override func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.performSegueWithIdentifier("goToPhotoSelectionVC", sender: image.resizeImage(800))
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegK_PhotoSelection) {
            let photoSelectionVC = segue.destinationViewController as? PhotoSelectionVC
            if let image = sender as? UIImage {
                photoSelectionVC?.addPhoto(image)
            } else if let images = sender as? [UIImage] {
                for image in images {
                    photoSelectionVC?.addPhoto(image)
                }
            }
        }
    }
    
    func didSelectedPhotos(notification: NSNotification) {
        if let photos = notification.userInfo![K_Selected_Photos] as? [UIImage] {
            self.food.photo = photos
            self.tbvNewFood?.reloadData()
        }
    }
    
    func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!) {
        let urlImage = result["url"] as! String
        self.food.photoURL?.append(urlImage)
        if self.food.photoURL?.count == self.food.photo?.count {
            let food = PFObject(className: "Food")
            food.setObject(self.food.name!, forKey: "name")
            food.setObject(self.food.isDrink!, forKey: "isDrink")
            food.setObject(self.food.subName!, forKey: "subName")
            food.setObject(self.food.price!, forKey: "price")
            food.setObject(self.food.cateID!, forKey: "CateID")
            food.setObject(self.food.kindOfMeal!, forKey: "kindOfMeal")
            food.setObject(self.food.mealTime!, forKey: "mealTime")
            food.setObject(self.food.specific!, forKey: "specific")
            food.setObject(self.food.descriptionFood!, forKey: "description")
            food.setObject(self.food.photoURL!, forKey: "photos")
            food.setObject(self.food.restaurant!, forKey: "restaurant")
            
            food.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    print("Object Uploaded")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print("Error: \(error) \(error!.userInfo)")
                }
                self.activityIndicator?.removeFromSuperview()
                self.isLoading = false
            }
        }
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
        
        if let price = self.food.price {
            cellTitle.cellOneLabel.text = "\(price)"
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
    
    func createAndConfigureCellKindOfMeal() -> CellKindOfMeal {
        let cellTitle = self.tbvNewFood?.dequeueReusableCellWithIdentifier("CellKindOfMeal") as! CellKindOfMeal
        
        if self.food.kindOfMeal?.characters.count > 0 {
            cellTitle.btnMain.tintColor = UIColor.redColor()
        } else {
            cellTitle.btnMain.tintColor = UIColor.redColor()
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
            cellPhoto.setPhotos(photo)
        }
            
        return cellPhoto
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        startEditField(at: indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let cateVC = storyboard.instantiateViewControllerWithIdentifier("CategoryVC") as! PFQueryTableViewController
            self.navigationController?.pushViewController(cateVC, animated: true)
            return
        case 5:
            return
        case 6:
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let mealTimeVC = storyboard.instantiateViewControllerWithIdentifier("MealTime")
            self.navigationController?.pushViewController(mealTimeVC, animated: true)
            return
        case 7:
            NSUserDefaults.standardUserDefaults().setObject(self.food.specific, forKey: K_Inputed_Text)
        case 8:
            NSUserDefaults.standardUserDefaults().setObject(self.food.descriptionFood, forKey: K_Inputed_Text)
        case 9:
            return
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
            self.food.price = (notification.userInfo![K_Inputed_Text] as? String)?.floatValue
        case 4:
            break
        case 5:
            break
        case 6:
            break
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
    
    func setKindOfMeal(notification: NSNotification) {
        let isMain = notification.object as? Bool
        if isMain == true {
            self.food.kindOfMeal = "ăn chính"
        } else {
            self.food.kindOfMeal = "ăn vặt"
        }
        self.tbvNewFood.reloadData()
    }
    
    func didInputWifi(notification: NSNotification) {
        let isHaveDrink = notification.object as? Bool
        self.food.isDrink = isHaveDrink
        self.tbvNewFood.reloadData()
    }
    
    func didChooseCategory(notification: NSNotification) {
        let cateID = notification.object as? String
        self.food.cateID = cateID
        self.tbvNewFood.reloadData()
    }
    
    func didChooseMealTime(notification: NSNotification) {
        let mealTime = notification.object as? String
        self.food.mealTime = mealTime
        self.tbvNewFood.reloadData()
    }
    
    @IBAction func saveNewFood(sender: AnyObject) {
        if self.food.name == nil || self.food.subName == nil || self.food.price == nil || self.food.cateID == nil || self.food.kindOfMeal == nil || self.food.mealTime == nil || self.food.specific == nil || self.food.descriptionFood == nil || self.food.isDrink == nil {
            let alert = UIAlertView.init(title: "Error", message: "You must input all information", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            if !isLoading {
                isLoading = true
                self.activityIndicator = AlertLoading.showAlertLoading(self.view)
                for photo in self.food.photo! {
                    let uploader = CLUploader(clouder, delegate: self)
                    uploader.upload(UIImagePNGRepresentation(photo), options: nil)
                }
            }
        }
    }
}

