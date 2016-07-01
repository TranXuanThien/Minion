//
//  CellMealTime.swift
//  mominion
//
//  Created by SarkozyTran on 6/22/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class CellMealTime: UITableViewCell {

    @IBOutlet weak var btnDinner: UIButton!
    @IBOutlet weak var btnAfternoon: UIButton!
    @IBOutlet weak var btnLunch: UIButton!
    @IBOutlet weak var btnMorning: UIButton!
    var mealTime = ""
    var isMorning = false
    var isLunch = false
    var isAfternoon = false
    var isDinner = false

    @IBAction func chooseMorning(sender: AnyObject) {
        btnMorning.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        mealTime += "sáng"
        NSNotificationCenter.defaultCenter().postNotificationName("inputMealTime", object: mealTime)
    }
    
    @IBAction func chooseLunch(sender: AnyObject) {
        btnLunch.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        mealTime += "trưa"
        NSNotificationCenter.defaultCenter().postNotificationName("inputMealTime", object: mealTime)
    }
    
    @IBAction func chooseAfternoon(sender: AnyObject) {
        btnAfternoon.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        mealTime += "chiều"
        NSNotificationCenter.defaultCenter().postNotificationName("inputMealTime", object: mealTime)
    }
    
    @IBAction func chooseDinner(sender: AnyObject) {
        btnDinner.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        mealTime += "tối"
        NSNotificationCenter.defaultCenter().postNotificationName("inputMealTime", object: mealTime)
    }
}
