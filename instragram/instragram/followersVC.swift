//
//  followersVC.swift
//  instragram
//
//  Created by David Null on 12/28/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

var show = String()
var user = String()

class followersVC: UITableViewController {

    //arrays to hold data received from servers
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    
    //array showing who do we follow
    var followArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title at the top
        self.navigationItem.title = show.uppercaseString
        
        
        if show == "followers" {
            loadFollowers()
        }
        
        if show == "followings" {
            loadFollowings()
        }

    }
    
    //loading followers
    func loadFollowers() {
        
        //STEP 1. Find in follow class people following user
        //find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                //clean up
                self.followArray.removeAll(keepCapacity: false)
            
                //STEP 2. Hold received data
                //find related objects depending on Query settings
                for object in objects! {
                    self.followArray.append(object.valueForKey("follower") as! String)
                }
                
                //STEP 3. find in User class data of users following "user"
                //find users following user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        //clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                    
                        //find related objects in user class of Parse
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            } else {
                print(error?.localizedDescription)
            }
        })
    }
    
    //loading followings
    func loadFollowings() {
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                //clean up
                self.followArray.removeAll(keepCapacity: false)
                
                //find related objects in follow class in Parse
                for object in objects! {
                    self.followArray.append(object.valueForKey("following") as! String)
                }
                
                //find users followed by user
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        //clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        
                        //find related objects in user class of parse
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            } else {
                print(error?.localizedDescription)
            }
        })
        
    }

   
    // MARK: - Table view data source

    //cell number
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        //STEP 1. connect data from server to objects
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        
        
        //STEP 2. show do user following or do not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
                    cell.followBtn.backgroundColor = .lightGrayColor()
                } else {
                    cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    cell.followBtn.backgroundColor = UIColor.greenColor()
                }
            }
        })
        
        //hide follow button for current user
        if cell.usernameLbl.text == PFUser.currentUser()!.username! {
            cell.followBtn.hidden = true
        }
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //recall cell to call further cell's data
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
        //if user tapped on himself, go home, else go guest
        if cell.usernameLbl.text! == PFUser.currentUser()!.username! {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }
    
    
    
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
