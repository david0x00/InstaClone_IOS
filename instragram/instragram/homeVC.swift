//
//  homeVC.swift
//  instragram
//
//  Created by David Null on 12/23/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

class homeVC: UICollectionViewController {

    //refresher variable
    var refresher: UIRefreshControl!
    //size of page
    var page : Int = 10
    
    var uuidArray = [String]()
    
    var picArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //just doing this to test uploading a post
        /*let data = UIImageJPEGRepresentation(UIImage(named: "funnycat.jpg")!, 0.5)
        let catfile = PFFile(name: "picture.jpg", data: data!)
        let table = PFObject(className: "posts")
        table["username"] = PFUser.currentUser()?.username
        table["uuid"] = 1
        table["ava"] = catfile
        table["pic"] = catfile
        table["title"] = "My first post"
        
        table.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("yay")
            } else {
                print(error?.localizedDescription)
            }
        }*/
        
        //create some followers
        /*let table = PFObject(className: "follow")
        table["follower"] = "yellow"
        table["following"] = "bob"
        table.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("loaded follow data")
            } else {
                print(error?.localizedDescription)
            }
        }*/
        
        
        //finished with testing
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.alwaysBounceVertical = true

        //background color
        collectionView?.backgroundColor = .whiteColor()
        
        //title name
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        //load posts
        loadPosts()
        
        
    }
    
    
    //refreshing function
    func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    //load posts function
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                var gag: Int
                //clean up
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)
                //find objects related to our query
                for object in objects! {
                    //have to convert to Int before converting to String
                    gag = object.valueForKey("uuid") as! Int
                    //print("\(gag)")
                    self.uuidArray.append("\(gag)")
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        })
    }
    
    //cell number
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // initial
        return picArray.count
        
        //test cells
        //return picArray.count * 20
    }
    
    //cell config
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        //get picture from the pic array
        //picArray[indexPath.row]
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        
        return cell
        
    }
    

    
    //header config
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        //STEP 1. Get user data
        //get users data with connections to collumns of PFUser class
        header.fullnameLbl.text = (PFUser.currentUser()?.objectForKey("fullname") as? String)?.uppercaseString
        header.webTxt.text = (PFUser.currentUser()?.objectForKey("web") as? String)
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.currentUser()?.objectForKey("bio") as? String
        header.bioLbl.sizeToFit()
        let avaQuery = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            //tested to make sure I got the image from the server.
            let pic = UIImage(data: data!)
            //let picjpg = UIImageJPEGRepresentation(pic!, 1)
            //let filename = "/Users/davidnull/Desktop/myimg.jpg"
            //picjpg?.writeToFile(filename, atomically: true)*/
            
            header.avaImg.image = pic
        }
        header.button.setTitle("edit profile", forState: UIControlState.Normal)
        
        //STEP 2. count total followers
        //count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            }
        })
        
        //count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.currentUser()!.username!)
        followers.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.followers.text = "\(count)"
            }
        })
        
        //count total followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followings.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.following.text = "\(count)"
            }
        })
        
        //STEP 3. Implement Tap Gestures
        //tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.posts.userInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followingsTap.numberOfTapsRequired = 1
        header.following.userInteractionEnabled = true
        header.following.addGestureRecognizer(followingsTap)
        
        
        return header
        
    }
    
    
    //tapped posts. automatically scrolls down to the start of the posts if there are enough to scroll
    func postsTap() {
        if !picArray.isEmpty {
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    //tapped followers label
    func followersTap() {
        user = PFUser.currentUser()!.username!
        show = "followers"
        //make reference
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        //present it
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    //tapped followings label
    func followingsTap() {
        
        user = PFUser.currentUser()!.username!
        show = "followings"
        //make reference to followersVC
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        //present to user
        self.navigationController?.pushViewController(followings, animated: true)
        
    }
    
    //clicked logout
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            if error == nil {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let signin = self.storyboard?.instantiateViewControllerWithIdentifier("signInVC") as! signInVC
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
            }
        }
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    /*override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }*/

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
