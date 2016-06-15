//
//  ViewController.swift
//  mominion
//
//  Created by SarkozyTran on 6/13/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query2 = PFQuery(className: "Cate")
        query2.selectKeys(["name"])
        query2.findObjectsInBackgroundWithBlock { (listCate: [PFObject]?, error: NSError?) in
            if error == nil {
                print("category la : \(listCate![1]["name"])")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


