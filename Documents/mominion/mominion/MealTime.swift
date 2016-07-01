//
//  MealTime.swift
//  mominion
//
//  Created by SarkozyTran on 6/29/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class MealTime: UITableViewController {
   
    let arrayMealTime = ["sáng", "trưa", "chiều", "tối"]
    var selects = [Int]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = arrayMealTime[indexPath.row]

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selects.contains(indexPath.row) {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            selects.removeAtIndex(selects.indexOf(indexPath.row)!)
        } else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            selects.append(indexPath.row)
        }
    }
    
    @IBAction func doneSetMealTime(sender: AnyObject) {
        self.selects.sortInPlace()
        if self.selects.count == 0 {
            let alert = UIAlertView.init(title: "Error", message: "You must choose one time", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            var mealTime = ""
            for index in self.selects {
                mealTime += arrayMealTime[index]
                if index != self.selects.last {
                   mealTime += ","
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("chooseMealTime", object: mealTime)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
