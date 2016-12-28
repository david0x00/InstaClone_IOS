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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //background color
        collectionView?.backgroundColor = .whiteColor()
        
        //title name
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    

    

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
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
        
        return header
        
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
