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

class NewRestaurantVC: BaseVC, CLUploaderDelegate {

    var StringImage:NSURL?
    @IBOutlet weak var resInformationtbv: UITableView!
    var inputingField: Int = -1
    var restaurant = Restaurant()
    
    var picker:UIDatePicker?
    var fromTime:String?
    var toTime:String?
    var isSetFromTime = true
    var currentDate:NSDate?
    var sigleTap:UITapGestureRecognizer?
    var btnHiddenPicker:UIButton?
    var activityIndicator:UIView?
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resInformationtbv.delegate = self
        resInformationtbv.dataSource = self
        self.resInformationtbv!.rowHeight = UITableViewAutomaticDimension
        self.resInformationtbv!.estimatedRowHeight = 296.0
        
        self.imagePicker.delegate = self
        triggerEvent()
        
        self.restaurant.photoURL = [String]()
        
        self.picker = UIDatePicker.init(frame: CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200));
        self.picker!.datePickerMode = UIDatePickerMode.Time
        self.view.addSubview(self.picker!)
        self.picker?.hidden = true
        self.picker?.backgroundColor = UIColor.whiteColor()
        self.picker?.addTarget(self, action: #selector(NewRestaurantVC.selectTime), forControlEvents: UIControlEvents.ValueChanged)
        
        btnHiddenPicker = UIButton.init(frame: CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 200, 100, 40))
        btnHiddenPicker!.setTitle("Done", forState:.Normal)
        btnHiddenPicker!.backgroundColor = UIColor.grayColor()
        btnHiddenPicker!.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btnHiddenPicker!.addTarget(self, action: #selector(NewRestaurantVC.doneChooseTime), forControlEvents: .TouchUpInside)
        self.view?.addSubview(btnHiddenPicker!)
        btnHiddenPicker?.hidden = true
        
    }
    
    func doneChooseTime() {
        self.picker?.hidden = true
        btnHiddenPicker?.hidden = true
    }

    func selectTime() {
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        if self.isSetFromTime {
            self.fromTime = timeFormatter.stringFromDate(self.picker!.date)
            self.currentDate = self.picker?.date
        } else {
            self.toTime = timeFormatter.stringFromDate(self.picker!.date)
        }
        self.resInformationtbv.reloadData()
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
    
    @IBAction func saveRestaurantInfo(sender: AnyObject) {
        if self.restaurant.name == nil || self.restaurant.address == nil || self.restaurant.openTime == nil || self.restaurant.priceRange == nil || self.restaurant.priceRange == nil || self.restaurant.wifi == nil {
            let alert = UIAlertView.init(title: "Error", message: "You must input all information", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            if !isLoading {
                isLoading = true
                self.activityIndicator = AlertLoading.showAlertLoading(self.view)
                for photo in self.restaurant.photo! {
                    let uploader = CLUploader(clouder, delegate: self)
                    uploader.upload(UIImagePNGRepresentation(photo), options: nil)
                }
            }
        }
    }
    
    func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!) {
        let urlImage = result["url"] as! String
        self.restaurant.photoURL?.append(urlImage)
        
        if self.restaurant.photoURL?.count == self.restaurant.photo?.count {
            let res = PFObject(className: "Restaurant")
            res.setObject(self.restaurant.name!, forKey: "name")
            res.setObject(self.restaurant.openTime!, forKey: "openingTime")
            res.setObject(self.restaurant.address!, forKey: "address")
            res.setObject(self.restaurant.wifi!, forKey: "wifiYes")
            res.setObject(self.restaurant.priceRange!, forKey: "priceRange")
            res.setObject(self.restaurant.specifi!, forKey: "specific")
            res.setObject(self.restaurant.photoURL!, forKey: "photos")
            res.saveInBackgroundWithBlock { (succeeded, error) -> Void in
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewRestaurantVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
        case 6:
            return createAndConfigureCellWifi()
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
        cellTitle.btnFromTime.addTarget(self, action: #selector(NewRestaurantVC.chooseFromTime), forControlEvents: UIControlEvents.TouchUpInside)
        cellTitle.btnToTime.addTarget(self, action: #selector(NewRestaurantVC.chooseToTime), forControlEvents: UIControlEvents.TouchUpInside)
        
        if self.fromTime?.characters.count > 0 {
            cellTitle.fromTime.text = self.fromTime!
            cellTitle.lblOpenTime.text = "From:"
        } else {
            cellTitle.lblOpenTime.text = "Open Time"
        }
        
        if self.toTime?.characters.count > 0 {
            cellTitle.toTime.text = self.toTime!
        }
        if self.toTime?.characters.count > 0 && self.fromTime?.characters.count > 0 {
            self.restaurant.openTime = self.fromTime! + "-" + self.toTime!
        }
        
        return cellTitle
    }
    
    func chooseFromTime() {
        self.picker?.hidden = false
        self.isSetFromTime = true
        btnHiddenPicker?.hidden = false
    }
    
    func chooseToTime() {
        self.picker?.hidden = false
        btnHiddenPicker?.hidden = false
        self.picker?.minimumDate = self.currentDate
        self.isSetFromTime = false
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
            cellTitle.cellOneLabel.text = "Specific"
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
    
    func createAndConfigureCellWifi() -> CellWifi {
        let cellTitle = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellWifi") as! CellWifi
        
        if self.restaurant.wifi == true {
            cellTitle.btnYes.tintColor = UIColor.redColor()
        } else {
            cellTitle.btnYes.tintColor = UIColor.redColor()
        }
        
        return cellTitle
    }
    
    func createAndConfigureCellPhoto() -> CellRestaurantPhoto {
        let cellPhoto = self.resInformationtbv?.dequeueReusableCellWithIdentifier("CellRestaurantPhoto") as! CellRestaurantPhoto
        if let photo = self.restaurant.photo {
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
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.name, forKey: K_Inputed_Text)
        case 1:
            showActionSheet(index)
            return
        case 2:
            return
        case 3:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.address, forKey: K_Inputed_Text)
        case 4:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.specifi, forKey: K_Inputed_Text)
        case 5:
            NSUserDefaults.standardUserDefaults().setObject(self.restaurant.priceRange, forKey: K_Inputed_Text)
        case 6:
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
    
    func triggerEvent() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewRestaurantVC.didInputProcessingField(_:)), name: EK_TextInputVC_did_input, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewRestaurantVC.didInputWifi(_:)), name: "inputWifi", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectedPhotos:",
            name: EK_PhotoSelectionVC_selected_photo,
            object: nil)
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
    
    func didInputWifi(notification: NSNotification) {
        let isHaveWifi = notification.object as? Bool
        self.restaurant.wifi = isHaveWifi
    }
    
    func didSelectedPhotos(notification: NSNotification) {
        if let photos = notification.userInfo![K_Selected_Photos] as? [UIImage] {
            self.restaurant.photo = photos
            self.resInformationtbv?.reloadData()
        }
    }
}

