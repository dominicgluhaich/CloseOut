//
//  ComposeViewController.swift
//  CloseOut
//
//  Created by Dominic Gluhaich on 9/28/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

@available(iOS 8.0, *)
class ComposeViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet var itemTitle: UITextField!
    
    @IBOutlet var itemDescription: UITextView!
    
    @IBOutlet var imageToPost: UIImageView!
    
    
    var currLocation: CLLocationCoordinate2D?
    var reset:Bool = false
    let locationManager = CLLocationManager()
    
        var activityIndicator = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                print("We have the current location!")
            } else {
                print("nah")
            }
        }
        
        self.itemDescription.selectedRange = NSMakeRange(0, 0)
        self.itemDescription.delegate = self
        self.itemDescription.becomeFirstResponder()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    
    @IBAction func uploadImage(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
        imageToPost.image = image
        
        
        
    }
    
    @IBAction func postPressed(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "nearPosts")
        
        if (currLocation != nil) {
            
            post["itemDescription"] = itemDescription.text
            
            post["itemTitle"] = itemTitle.text
            
            post["userId"] = PFUser.currentUser()!.objectId!
            
            post["username"] = PFUser.currentUser()!.username!
            
            post["location"] = PFGeoPoint(latitude: currLocation!.latitude , longitude: currLocation!.longitude)
            
            let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
            
            let imageFile = PFFile(name: "image.jpg", data: imageData!)
            
            post["postedImage"] = imageFile
            
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)

                    self.displayAlert("Your item was posted!", message: "Now just wait and see who messages you!")
                    
                    
                    self.itemDescription.text = ""
                    
                    self.imageToPost.image = UIImage(named: "images.png")
                    
                } else {
                    
                    self.displayAlert("Could not post item", message: "Please try again later")
                    
                }
            }
            
        }
            
                }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true , completion: nil)

    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        locationManager.stopUpdatingLocation()
        
        if(locations.count > 0){
            let location = locations[0]
            currLocation = location.coordinate
            
            
            print(location)
        } else {
            print("shit")
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    

    /*
    
    func textViewDidChange(textView: UITextView) {
        if(reset == false){
            self.itemDescription.text = String(Array(self.itemDescription.text.characters)[0])
            reset = true
        }
    }
*/
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
