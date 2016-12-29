//
//  followersCell.swift
//  instragram
//
//  Created by David Null on 12/28/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    
    //default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //round the pictures
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //clicked follow unfollow
    @IBAction func followBtn_click(sender: AnyObject) {
        let title = followBtn.titleForState(.Normal)
        
        //to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = usernameLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.followBtn.backgroundColor = .greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
        //unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo: usernameLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                self.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.followBtn.backgroundColor = .lightGrayColor()
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
