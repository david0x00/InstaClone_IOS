//
//  ViewController.swift
//  instragram
//
//  Created by David Null on 12/19/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import Parse
import UIKit

class ViewController: UIViewController {

    //variables used in the part about learning how to query and create
    /*@IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var senderLbl: UILabel!

    @IBOutlet weak var receiverLbl: UILabel!
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //to create a class / collection / table in Heroku
        //PFObject means creation of table or some data in table.
        
        
        //unwrap / take image from UIImageView
        // you must have the picture already in the image view
        /*
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        let file = PFFile(name: "picture.jpg", data: data!)
        
        
        let table = PFObject(className: "messages")
        table["sender"] = "David"
        table["receiver"] = "Bob"
        table["picture"] = file
        
        table.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("saved!")
            } else {
                print(error)
            }
        }*/
        
        
        
        /*let object = PFObject(className: "testObject")
        object["name"] = "Bill"
        object["lastname"] = "Alexander"
        object.saveInBackgroundWithBlock { (done:Bool, error:NSError?) -> Void in
            if done {
                print("Saved in Server")
            } else {
                print(error)
            }
        }*/
        
        
        //retrieve data from the server
        /*let receiver = String()
        let sender = String()
        let filepicture = [PFFile]()
        
        let info = PFQuery(className: "messages")
        info.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                //take each object from list of objects.  object = array of data
                for object in objects! {
                    
                    //declare shortcuts to store data from server
                    let sender = object["sender"] as! String
                    let receiver = object["receiver"] as! String
                    
                    self.senderLbl.text = "Sender: \(sender)"
                    self.receiverLbl.text = "Receiver: \(receiver)"
                    
                    //get picture from picture column in server, and give it to user
                    object["picture"].getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
                        if error == nil {
                            if data != nil {
                                self.imageView.image = UIImage(data: data!)
                            }
                        } else {
                            print(error)
                        }
                    })
                    
                    
                }
                
            } else {
                print(error)
            }
        }*/
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

