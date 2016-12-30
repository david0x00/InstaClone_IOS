//
//  guestVC.swift
//  instragram
//
//  Created by David Null on 12/29/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class guestVC: UICollectionViewController {
    
    //UI objects
    var refresher: UIRefreshControl!
    var page : Int = 10
    
    //arrays to hold data from the server
    var uuidArray = [String]()
    var picArray = [PFFile]()

    //default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        self.collectionView?.backgroundColor = .whiteColor()

        //allow vertical scroll always
        self.collectionView?.alwaysBounceVertical = true
        
        //navigation title
        self.navigationItem.title = guestname.last
        
        //new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backBtn
        
        //swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        //call load posts function
        loadPosts()
        
    }
    
    
    func back(sender:UIBarButtonItem) {
        //push back
        self.navigationController?.popViewControllerAnimated(true)
        
        //clean guestusername or deduct the last username from guestname array
        if !guestname.isEmpty {
            guestname.removeLast()
        }
        
    }
    
    //refresh function
    func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    //posts loading function
    func loadPosts() {
        var gag:Int = 0
        //load posts
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page
        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                //find related objects
                for object in objects! {
                    //hold found information in arrays
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
        return picArray.count
    }
    
    //cell configuration
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        //connect data from array to picImg object from picture cell class
        picArray[indexPath.row].getDataInBackgroundWithBlock ({ (data:NSData?, error:NSError?) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        })
        
        return cell
        
    }
    
    //header config
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        //STEP 1. Load data of guest
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestname.last!)
        infoQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                //shown wrong user
                if objects!.isEmpty {
                    print("wrong user")
                }
                
                //find related to user information
                for object in objects! {
                    header.fullnameLbl.text = (object.objectForKey("fullname") as? String)?.uppercaseString
                    header.bioLbl.text = object.objectForKey("bio") as? String
                    header.bioLbl.sizeToFit()
                    header.webTxt.text = object.objectForKey("web") as? String
                    header.webTxt.sizeToFit()
                    let avaFile: PFFile = (object.objectForKey("ava") as? PFFile)!
                    avaFile.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
                        header.avaImg.image = UIImage(data: data!)
                    })
                    
                    
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //STEP 2. show if current user follows guest user or not
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.whereKey("following", equalTo: guestname.last!)
        followQuery.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                if count == 0 {
                    header.button.setTitle("FOLLOW", forState: UIControlState.Normal)
                    header.button.backgroundColor = .lightGrayColor()
                } else {
                    header.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    header.button.backgroundColor = .greenColor()
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //STEP 3. count statistics
        //count posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestname.last!)
        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //count followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: guestname.last!)
        followers.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.followers.text = "\(count)"
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //count followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: guestname.last!)
        followings.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.following.text = "\(count)"
            } else {
                print(error)
            }
        })
        
        
        //STEP 4. implement tap gestures
        //tap to posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.posts.userInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        //tap the followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap the followings
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followingsTap.numberOfTapsRequired = 1
        header.following.userInteractionEnabled = true
        header.following.addGestureRecognizer(followingsTap)
        
        
        return header
        
    }
    
    //tapped posts label
    func postsTap() {
        if !picArray.isEmpty {
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    func followersTap() {
        user = guestname.last!
        show = "followers"
        
        //define followers VC
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        //navigate to it
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap() {
        user = guestname.last!
        show = "followings"
        
        //define followersVC 
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        //navigate to it
        self.navigationController?.pushViewController(followings, animated: true)
        
    }
    
    
    
    
    
    
}
