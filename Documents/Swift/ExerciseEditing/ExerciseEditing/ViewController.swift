//
//  ViewController.swift
//  ExerciseEditing
//
//  Created by SarkozyTran on 2/25/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var processParagrph = EEProcessParagraph()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.text = "Con ga con cho\n Con vit con Ngan\nGa con di lung tung";
        textView.textAlignment = NSTextAlignment.Left
        textView.textColor = UIColor.blackColor()
        
        // load tool bar customs
        let toolBar = NSBundle.mainBundle().loadNibNamed("EEToolBarCustom", owner: self, options: nil).first
        
        self.textView.inputAccessoryView = toolBar as? UIView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setFontSizeParagraph(sender: AnyObject) {
        // get range of paragraph at current cursor location
        let rangeParagraph = EEProcessParagraph.getCursorLocation(self.textView)
        
        // add attribute font size for paragraph
        processParagrph.setFontSizeParagraph(rangeParagraph!, textView: self.textView)
    }
    
    @IBAction func setAlignmentParagraph(sender: AnyObject) {
        // get range of paragraph at current cursor location
        let rangeParagraph = EEProcessParagraph.getCursorLocation(self.textView)
        
        // set alignment for paragraph
        processParagrph.setAlignmentParagraph(rangeParagraph!, textView: self.textView)
    }
    
    @IBAction func setFontColorParagraph(sender: AnyObject) {
        // get range of paragraph at current cursor location
        let rangeParagraph = EEProcessParagraph.getCursorLocation(self.textView)
        
        // add attribute color for paragraph
        processParagrph.setFontColorParagraph(rangeParagraph!, textView: self.textView)
    }
}

