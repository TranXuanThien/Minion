//
//  EEProcessParagraph.swift
//  ExerciseEditing
//
//  Created by SarkozyTran on 2/25/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

enum FontSize:CGFloat {
    case SMALL = 10
    case MEDIUM = 20
    case LARGE = 30
}

let FirstColor = UIColor.blackColor()
let SecondColor = UIColor.greenColor()
let ThridColor = UIColor.brownColor()

class EEProcessParagraph: NSObject {
    class func detectParagraph(location:Int, textView:UITextView) -> NSRange {
    
        var paragraphs:[String] = textView.text.componentsSeparatedByString("\n");
        
        var range:NSRange!
        
        for var index = 0; index < paragraphs.count; ++index {
            if (location >= (textView.text as NSString) .rangeOfString(paragraphs[index]).location) {
                range = (textView.text as NSString) .rangeOfString(paragraphs[index])
            }
        }
        
        return range
    }
    
    class func getCursorLocation(inView:UITextView) -> NSRange? {
        return self.detectParagraph(inView.selectedRange.location, textView: inView)
    }
    
    func setFontSizeParagraph(rangeParagraph:NSRange, textView:UITextView) {
        
        // get current attribute of cursor location
        let dic = textView.textStorage.attributesAtIndex(rangeParagraph.location, effectiveRange: nil)
        
        var fontSize:FontSize
        
        // change font size small - medium - large
        if dic[NSFontAttributeName] as! NSObject == (UIFont.systemFontOfSize(FontSize.MEDIUM.rawValue)) {
            fontSize = FontSize.LARGE
        } else if dic[NSFontAttributeName] as! NSObject == UIFont.systemFontOfSize(FontSize.LARGE.rawValue) {
            fontSize = FontSize.SMALL
        } else {
            fontSize = FontSize.MEDIUM
        }
        
        // add attribute font size for paragraph
        textView.textStorage.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(fontSize.rawValue), range: NSMakeRange(rangeParagraph.location, rangeParagraph.length))
    }
    
    func setAlignmentParagraph(rangeParagraph:NSRange, textView:UITextView) {
        
        // get current attribute of cursor location
        let dic = textView.textStorage.attributesAtIndex(rangeParagraph.location, effectiveRange: nil)
        
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        
        // change alignment left - center - right
        if (dic[NSParagraphStyleAttributeName]?.alignment == NSTextAlignment.Left) {
            paragraphStyle.alignment = NSTextAlignment.Center
        } else if (dic[NSParagraphStyleAttributeName]?.alignment == NSTextAlignment.Center) {
            paragraphStyle.alignment = NSTextAlignment.Right
        } else {
            paragraphStyle.alignment = NSTextAlignment.Left
        }
        
        // add attribute alignment for paragraph
        textView.textStorage.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(rangeParagraph.location, rangeParagraph.length))
    }
    
    func setFontColorParagraph(rangeParagraph:NSRange, textView:UITextView) {
        // get current attribute of cursor location
        let dic = textView.textStorage.attributesAtIndex(rangeParagraph.location, effectiveRange: nil)
        
        // color of cursor location
        let currentColor = dic[NSForegroundColorAttributeName] as? UIColor
        
        // new color to set color for paragraph
        var newColor:UIColor
        
        // change color black - green - brown
        if currentColor == FirstColor {
            newColor = SecondColor;
        } else if currentColor == SecondColor {
            newColor = ThridColor;
        } else {
            newColor = FirstColor;
        }
        
        // add attribute color for paragraph
        textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: newColor, range: NSMakeRange(rangeParagraph.location, rangeParagraph.length))
    }
}
