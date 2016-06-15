//
//  TextInputVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/14/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

let SegK_TextInputVC = "inputTextSegue"
let EK_TextInputVC_did_input = "EK_TextInputVC_did_input"
let K_Inputed_Text = "K_Inputed_Text"

class TextInputVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tvMain: UITextView!
    var isHashtag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(TextInputVC.doneTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(TextInputVC.cancelTapped))
        setupEditor()
    }
    
    func setupEditor() {
        if let inputedValue = NSUserDefaults.standardUserDefaults().objectForKey(K_Inputed_Text) as? String {
            self.tvMain?.text = inputedValue
        }
        NSUserDefaults.standardUserDefaults().setObject("", forKey: K_Inputed_Text)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.tvMain?.becomeFirstResponder()
        if isHashtag {
            tvMain.delegate = self
        }
    }
    
    func doneTapped() {
        NSNotificationCenter.defaultCenter().postNotificationName(EK_TextInputVC_did_input, object: nil, userInfo: [K_Inputed_Text: self.tvMain.text])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissView() {
        self.tvMain?.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        } else {
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
