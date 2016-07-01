//
//  CellKindOfMeal.swift
//  mominion
//
//  Created by SarkozyTran on 6/27/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class CellKindOfMeal: UITableViewCell {
    @IBOutlet weak var btnMain: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    var isMain = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func chooseMainMeal(sender: AnyObject) {
        isMain = true
        btnMain.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        btnSub.setImage(UIImage(named: "ic_check_box"), forState: .Normal)
        NSNotificationCenter.defaultCenter().postNotificationName("inputKindOfMeal", object: isMain)
    }
    
    @IBAction func chooseSubMeal(sender: AnyObject) {
        isMain = false
        btnSub.setImage(UIImage(named: "ic_checked_box"), forState: .Normal)
        btnMain.setImage(UIImage(named: "ic_check_box"), forState: .Normal)
        NSNotificationCenter.defaultCenter().postNotificationName("inputKindOfMeal", object: isMain)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
