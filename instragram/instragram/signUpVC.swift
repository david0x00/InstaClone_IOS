//
//  signUpVC.swift
//  instragram
//
//  Created by David Null on 12/20/16.
//  Copyright © 2016 David Null. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    //text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    //buttons
    @IBOutlet weak var signUpBtn: UIScrollView!
    @IBOutlet weak var cancelBtn: UIScrollView!
    
    
    //scroll view
    @IBOutlet weak var scrollView: UIScrollView!

    //reset default size
    var scrollViewHeight: CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollview frame size
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        
        //check notifications if keyboard is showing or not.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        
        //declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyBoardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        //tap profile picture
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        avaImg.userInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        
        //allignment  -- DOOO LATER
        avaImg.frame = CGRectMake(self.view.frame.size.width / 2 - 40, 40, 80, 80)

        
    }
    
    //load image function
    //needed to include some other classes at the very top
    func loadImg(recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //connect selected image to our image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hide keyboard if tapped
    func hideKeyBoardTap(recognizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // show keyboard func
    func showKeyboard(notification:NSNotification) {
        
        //define keyboard size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        //move up user interface
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
        
    }
    
    //move down UI
    func hideKeyboard(notification:NSNotification) {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
            
        }
    }

    
    
    @IBAction func signUpBtn_click(sender: AnyObject) {
        print("sign up button clicked")
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        
        //if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPassword.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty) {
            
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //check passwords
        if passwordTxt.text != repeatPassword.text {
            let alert = UIAlertController(title: "Passwords", message: "do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //send the stuff to the server
        let user = PFUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text
        //we have to create these next fields
        user["fullname"] = fullnameTxt.text?.lowercaseString
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercaseString
        //assign these later in edit profile
        user["tel"] = ""
        user["gender"] = ""
        //send img (0 - high compression, 1 - as it is)
        let avadata = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avadata!)
        user["ava"] = avaFile
        
        //actually send the stuff
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("registered")
                //remembers logged in user
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //call login function from AppDelegate class
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
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        //hide keyboard
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
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
