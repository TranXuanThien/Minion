//
//  LoginVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/13/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    var userList:NSArray?
    var activityIndicator:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(sender: AnyObject) {
        if !self.tfUserName.text!.isEmpty && !self.tfPassword.text!.isEmpty {
            self.activityIndicator = AlertLoading.showAlertLoading(self.view)
            PFUser.logInWithUsernameInBackground(self.tfUserName.text!, password: self.tfPassword.text!) { (user, error) -> Void in
                if error == nil {
                    print("succesful")
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let resVC = mainStoryboard.instantiateViewControllerWithIdentifier("RestaurantVC") as! RestaurantVC
                    self.navigationController?.pushViewController(resVC, animated: true)
                } else {
                    print("error: \(error!.userInfo)")
                    let alert = UIAlertView.init(title: "Error", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                self.activityIndicator?.removeFromSuperview()
            }
        } else {
            let alert = UIAlertView.init(title: "Error", message: "You must input all items", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}

