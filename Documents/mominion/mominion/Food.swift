//
//  Food.swift
//  mominion
//
//  Created by SarkozyTran on 6/16/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class Food: NSObject {
    
    var photo:[UIImage]?
    var photoURL:[String]?
    var name:String?
    var subName:String?
    var price:Float?
    var cateID:String?
    var kindOfMeal:String?
    var mealTime:String?
    var specific:String?
    var descriptionFood:String?
    var isDrink:Bool?
    var restaurant:String?
    
    override init() {
        
    }
}
