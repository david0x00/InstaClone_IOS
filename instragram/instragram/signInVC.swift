//
//  signInVC.swift
//  instragram
//
//  Created by David Null on 12/20/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    //text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    //buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //label of font
        label.font = UIFont(name: "Pacifico", size: 25)
        
        //background
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        bg.image = UIImage(named: "space_bakground.jpeg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        label.frame = CGRectMake(10, 80, self.view.frame.width - 20, 50)
        
        //allignment
        usernameTxt.frame = CGRectMake(10, label.frame.origin.y + 70, self.view.frame.size.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        forgotBtn.frame = CGRectMake(10, passwordTxt.frame.origin.y + 30, self.view.frame.size.width - 20, 30)
        signInBtn.frame = CGRectMake(20, forgotBtn.frame.origin.y + 40, self.view.frame.size.width / 4, 30)
        signUpBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20, signInBtn.frame.origin.y, self.view.frame.size.width / 4, 30)

        //tap to dismiss keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    
    func hideKeyboard(recognizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func signInBtn_Click(sender: AnyObject) {
        print("Sign In Button Pressed")
        
        //hide keyboard
        self.view.endEditing(true)
        
        //if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            //show alert message
            let alert = UIAlertController(title: "Please", message: "fill in fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //login functions
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:NSError?) -> Void in
            if error == nil {
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //call login function
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            } else {
                //show alert message
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
