//
//  RegisterVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/30/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    var activityIndicator:UIView?

    @IBAction func registerUser(sender: AnyObject) {
        if (!self.tfUserName.text!.isEmpty || !self.tfPassword.text!.isEmpty || !self.tfEmail.text!.isEmpty) {
            var newUser = PFUser()
            newUser.username = self.tfUserName.text!
            newUser.email = self.tfEmail.text!
            newUser.password = self.tfPassword.text!
            newUser.signUpInBackgroundWithBlock({ (isSuccess, error) in
                if error == nil {
                    print("success")
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let resVC = mainStoryboard.instantiateViewControllerWithIdentifier("RestaurantVC") as! RestaurantVC
                    self.navigationController?.pushViewController(resVC, animated: true)
                } else {
                    print("error: \(error!.userInfo)")
                    let alert = UIAlertView.init(title: "Error", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            })
        } else {
            let alert = UIAlertView.init(title: "Error", message: "You must input all items", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}
