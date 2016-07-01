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
        btnNo.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        btnYes.setImage(UIImage(named: "ic_check_box"), forState: .Normal)
        NSNotificationCenter.defaultCenter().postNotificationName("inputWifi", object: isHaveWifi)
    }
    
    @IBAction func haveWifi(sender: AnyObject) {
        isHaveWifi = true
        btnYes.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        btnNo.setImage(UIImage(named: "ic_check_box"), forState: .Normal)
        NSNotificationCenter.defaultCenter().postNotificationName("inputWifi", object: isHaveWifi)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
