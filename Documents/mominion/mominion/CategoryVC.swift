//
//  CategoryVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/16/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class CategoryVC: PFQueryTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var rowChecked:Int?
    var lastIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Cate"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Cate"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }
        
        query.orderByDescending("createdAt")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        if let object = object {
            cell!.textLabel?.text = object["cateID"] as? String
        }
        
        if indexPath.row == rowChecked {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ((indexPath.row + 1) > objects?.count) {
            loadNextPage()
            return
        }

        if indexPath.isEqual(lastIndexPath) {
            return
        }
        
        if lastIndexPath != nil {
            tableView.cellForRowAtIndexPath(lastIndexPath!)?.accessoryType = .None
        }
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        lastIndexPath = indexPath
        rowChecked = indexPath.row
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    @IBAction func didFinishChooseCate(sender: AnyObject) {
        if rowChecked == nil {
            let alert = UIAlertView.init(title: "Error", message: "You must choose one category", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("chooseCategory", object: objects![rowChecked!]["cateID"])
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
