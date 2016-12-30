//
//  headerView.swift
//  instragram
//
//  Created by David Null on 12/23/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

class headerView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!

    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    //clicked follow button from guestVC
    @IBAction func followBtn_clicked(sender: AnyObject) {
        let title = button.titleForState(.Normal)
        
        //to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = guestname.last!
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.button.backgroundColor = .greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            //unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                self.button.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.button.backgroundColor = .lightGrayColor()
                            } else {
                                print(error?.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
            
        }

    }
    
}
