//
//  CellWifi.swift
//  mominion
//
//  Created by SarkozyTran on 6/14/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class CellWifi: UITableViewCell {

    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    var isHaveWifi = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func notWifi(sender: AnyObject) {
        isHaveWifi = false
        NSNotificationCenter.defaultCenter().postNotificationName("inputWifi", object: isHaveWifi)
    }
    
    @IBAction func haveWifi(sender: AnyObject) {
        isHaveWifi = true
        NSNotificationCenter.defaultCenter().postNotificationName("inputWifi", object: isHaveWifi)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
