//
//  resetPasswordVC.swift
//  instragram
//
//  Created by David Null on 12/20/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    
    @IBAction func resetBtn_click(sender: AnyObject) {
        //hide keyboard
        self.view.endEditing(true)
        
        //if email text field is empty
        if emailTxt.text!.isEmpty {
            //show alert
            let alert = UIAlertController(title: "Email Field", message: "is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //get email from server
        PFUser.requestPasswordResetForEmailInBackground(emailTxt.text!) { (success:Bool, error:NSError?) -> Void in
            if success {
                
                //show alert message
                let alert = UIAlertController(title: "Email for resetting password", message: "has been sent", preferredStyle: UIAlertControllerStyle.Alert)
                //if ok is pressed then call dismiss function
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        //hide keyboard
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
