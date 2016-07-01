//
//  CellRestaurantPhoto.swift
//  mominion
//
//  Created by SarkozyTran on 6/14/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class CellRestaurantPhoto: UITableViewCell {

    @IBOutlet weak var scvSlide: UIScrollView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        for index in 0...3 {
            let imageView = UIImageView(frame: CGRectMake(CGFloat(index)*scvSlide.frame.size.width, 0, scvSlide.frame.size.width, scvSlide.frame.size.height))
            imageView.tag = index + 1
            imageView.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            scvSlide.addSubview(imageView)
        }
        scvSlide.scrollEnabled = true
        scvSlide.pagingEnabled = true
        scvSlide.showsHorizontalScrollIndicator = false
        scvSlide.showsVerticalScrollIndicator = false
        scvSlide.userInteractionEnabled = false
        self.contentView.addGestureRecognizer(scvSlide.panGestureRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPhotos(photos:[UIImage]) {
        reSetupSubImageViews()
        labelTitle.hidden = true
        scvSlide.contentSize = CGSizeMake(CGFloat(photos.count)*scvSlide.frame.size.width, scvSlide.frame.size.height)
        for tag in 1...photos.count {
            let imageView = scvSlide.viewWithTag(tag) as? UIImageView
            if let imageV = imageView {
                imageV.image = photos[tag-1]
            }
        }
    }
    
    func reSetupSubImageViews(){
        for view in scvSlide.subviews {
            if let imageView = view as? UIImageView {
                imageView.frame = CGRectMake(CGFloat(imageView.tag-1)*scvSlide.frame.size.width, 0, scvSlide.frame.size.width, scvSlide.frame.size.height)
            }
        }
    }
}
