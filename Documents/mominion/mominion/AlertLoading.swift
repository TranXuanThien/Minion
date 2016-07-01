//
//  AlertLoading.swift
//  mominion
//
//  Created by SarkozyTran on 6/30/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class AlertLoading: NSObject {
    
    class func showAlertLoading(view:UIView)-> UIView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        let subView = UIView.init(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        subView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        subView.addSubview(activityIndicator)
        view.addSubview(subView)
        
        return subView
    }
}
