//
//  RestaurantVC.swift
//  mominion
//
//  Created by SarkozyTran on 6/13/16.
//  Copyright © 2016 SarkozyTran. All rights reserved.
//

import UIKit

class RestaurantVC: PFQueryTableViewController, UISearchBarDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.title = "Restaurants"
    }

    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Restaurant"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Restaurant"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        if searchBar.text?.characters.count > 0 {
            query.whereKey("name", containsString: searchBar.text!)
        }
        
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }
        
        query.orderByDescending("createdAt")
        
        return query
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadObjects()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        self.loadObjects()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }

        if let object = object {
            cell!.textLabel?.text = object["name"] as? String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ((indexPath.row + 1) > objects?.count) {
            loadNextPage()
            return;
        }
        self.performSegueWithIdentifier("goToFood", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToFood" {
            let indexPath = sender as? NSIndexPath
            let object = objects![indexPath!.row]
            let foodVC = segue.destinationViewController as? FoodVC
            foodVC?.restaurantID = object.objectId
        }
    }
}
