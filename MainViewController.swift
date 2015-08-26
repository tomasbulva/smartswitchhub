//
//  MainViewController.swift
//  smart switch hub
//
//  Created by Tomas Bulva on 7/5/15.
//  Copyright (c) 2015 tomasbulva. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var items = [NSManagedObject]()
    var editStatus = false
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBAction func Edit(sender: AnyObject) {
        if editStatus == true {
            self.tableView.setEditing(false, animated: true)
            EditButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: nil)
                //= "Edit"
            editStatus = false
        }else{
            self.tableView.setEditing(true, animated: true)
//            EditButton.title = "Done"
            EditButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: nil)
            editStatus = true
        }
        
    }
    @IBAction func Cancel(segue:UIStoryboardSegue) {}
    @IBAction func Save(segue:UIStoryboardSegue) {
        if let sourceView = segue.sourceViewController as? SaveViewController {
            
            //print(sourceView.label)
            //print(sourceView.ipstring)
            saveData(sourceView.label.text, ipstring: sourceView.ipstring.text)
        }
        
    }
    
    func saveData(label:String, ipstring:String) -> Void
    {
        //print(label)
        //print(ipstring)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("Switch", inManagedObjectContext: managedContext)
        let myswitch = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        myswitch.setValue(label, forKey: "label")
        myswitch.setValue(ipstring, forKey: "ip")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  

        items.append(myswitch)
        self.reloadTableViewContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Switch")
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        if let results = fetchedResults {
            items = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        //print(items)
        self.reloadTableViewContent()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectAllRows()
    }
    
    func deselectAllRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
            for indexPath in selectedRows {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    func reloadTableViewContent() {
            self.tableView.reloadData()
            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)

    }
    
    // MARK: Refresh Content
    
    let basicCellIdentifier = "myCell"
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                self.items.removeAtIndex(indexPath.row)
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.tableView.editing) {
            return UITableViewCellEditingStyle.Delete;
        }
        
        return UITableViewCellEditingStyle.None;
    }
    
    func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            // remove the dragged row's model
            let val = self.items.removeAtIndex(sourceIndexPath.row)
            
            // insert it into the new position
            self.items.insert(val, atIndex: destinationIndexPath.row)
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> CellTableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! CellTableViewCell
        
        setTitleForCell(cell, indexPath: indexPath)
        setSwitchForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setTitleForCell(cell:CellTableViewCell, indexPath:NSIndexPath) {
        var item = items[indexPath.row]
        var label = item.valueForKey("label") as? String
        var ip = item.valueForKey("ip") as! String
        
        let URLHeader = "http://"
        var URLIP = ip // do some cleaning
        var URLCommand = "/cgi-bin/json.cgi?get=state"
        
        println("\(URLHeader)\(URLIP)\(URLCommand)")
        
        Alamofire.request(.GET, "\(URLHeader)\(URLIP)\(URLCommand)").responseJSON() {
            (request, response, JSON, error) in
            
            let info = JSON as? NSDictionary // info will be nil if it's not an NSDictionary
            let result = info?["state"] as? String // str will be nil if info is nil or the value for "access_key" is not a String
            
            if result == "off" {
                cell.mainSwitch.setOn(false, animated:false)
            }else{
                cell.mainSwitch.setOn(true, animated:false)
            }
        }
        //cell.mainSwitch.setOn(false, animated:true)
        
        cell.titleLabel!.text = label
        cell.ipstring = ip
        //print("generating cell's label \(label)")
        //print("generating cell's ip \(ip)")
        //cell.titleLabel.text = item
    }
    
    func setSwitchForCell(cell:CellTableViewCell, indexPath:NSIndexPath) {
        cell.mainSwitch.setOn(true, animated:false)
    }

}
