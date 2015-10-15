//
//  FeedTableViewController.swift
//  CloseOut
//
//  Created by Dominic Gluhaich on 9/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreLocation


@available(iOS 8.0, *)
class FeedTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var currLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var itemDescriptions = [String]()
    var imageFiles = [PFFile]()
    var itemTitles = [String]()
    var usernames = [String]()
    var users = [String: String]()
    
    
  
    var refresher: UIRefreshControl!
    
    // TRY BASIC QUERY ON PARSE
    
    
    // Think of a diferent way to do the queries that will fetch the data correctly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
                print("Anonymous login failed.")
            } else {
                print("Anonymous user logged in.")
            }
        }
        let query = PFQuery.queryForUser()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let users = objects {
                self.imageFiles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                self.itemTitles.removeAll(keepCapacity: true)
                self.itemDescriptions.removeAll(keepCapacity: true)
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.username!] = user.username!
                        print("Successfully retrieved \(objects!.count) users.")
                        
                    }
                }
            }
            let query = PFQuery(className:"nearPosts")
            query.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects as! [PFObject]! {
                        for object in objects {
                            self.imageFiles.append(object["postedImage"] as! PFFile)
                            self.itemDescriptions.append(object["itemDescription"] as! String)
                            self.itemTitles.append(object["itemTitle"] as! String)
                            self.usernames.append(object["username"] as! String)
                            self.tableView.reloadData()
                            print(self.usernames)
                            if self.usernames.isEmpty {
                                print("usernames is empty")
                            } else {
                                print("Usernames ain't empty")
                            }


                        }
                        print("Successfully retrieved \(objects.count) posts.")
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        
        print(usernames)
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                print("We have the current location!")
            } else {
                print("nah")
            }
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {

        var query = PFQuery(className:"nearPosts")
        query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock {
            (String, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(String!.count) scores.")
                // Do something with the found objects
                if let String = objects as! [String]! {
                    for object in objects {
                        self.usernames.append(object["username"] as! String)
                        print(self.usernames)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        /*
        let query = PFQuery.queryForUser()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let users = objects {
                self.imageFiles.removeAll(keepCapacity: true)
                self.itemTitles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                self.itemDescriptions.removeAll(keepCapacity: true)
                    for object in users {
                    
                    if let user = object as? PFUser {
                        
                        print("Successfully retrieved \(objects!.count) users.")

                    }
                }
            }
            let query = PFQuery(className:"nearPosts")
            query.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects as! [PFObject]! {
                        for object in objects {
                            self.imageFiles.append(object["postedImage"] as! PFFile)
                            self.itemDescriptions.append(object["itemDescription"] as! String)
                            self.itemTitles.append(object["itemTitle"] as! String)
                            self.usernames.append(object["username"] as! String)
                            self.tableView.reloadData()
                            
                        }
                        print("Successfully retrieved \(objects.count) posts.")
                        print(self.itemTitles)

                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        self.refresher.endRefreshing()
        */
    }

        /*
        let query = PFQuery(className:"nearPosts")
        //let objectId = nearPosts.objectId

        query.whereKey("nearPosts", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
        
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) items.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
*/
        /*
        let usersQuery = PFUser.query()
        
       usersQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
        if let users = objects {
            
            self.itemDescriptions.removeAll(keepCapacity: true)
            self.itemTitles.removeAll(keepCapacity: true)
            self.users.removeAll(keepCapacity: true)
            self.usernames.removeAll(keepCapacity: true)
            
            for object in users {
                if let user = object as? PFUser {
                    
                    self.users[user.objectId!] = user.username!
                }
            }
        }

        if let queryLoc = self.currLocation {
            
            let getUsersQuery = PFQuery(className: "nearPosts")
            getUsersQuery.whereKey("username", equalTo: (PFUser.currentUser()?.objectId!)!)
            getUsersQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 50)
            getUsersQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        
                        let nearUser = object["username"] as! String
                        let query = PFQuery(className: "nearPosts")
                        query.whereKey("username", equalTo: nearUser)
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            if let objects = objects {
                                for object in objects {
                                    self.itemDescriptions.append(object["itemDescription"] as! String)
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    self.itemTitles.append(object["itemTitle"] as! String)
                                    self.usernames.append(self.users[object["userId"] as! String]!)
                                    
                                    
                                    self.tableView.reloadData()
                                    print(self.usernames)
                                    print(self.itemDescriptions)

                                }
                            }
                        })
                    }
                }
            })
        }

       })

*/
        


    
    
        /*
        var query = PFUser.query()
    
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
    
        if let users = objects {
    
        self.usernames.removeAll(keepCapacity: true)
        self.itemTitles.removeAll(keepCapacity: true)
        self.itemDescriptions.removeAll(keepCapacity: true)
        
        
        for object in users {
        
        if let user = object as? PFUser {
        
        self.users[user.objectId!] = user.username!
        
        }
        }
        
        var nearUser = PFQuery(className: "User")
        nearUser.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        
        nearUser.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
        if let objects = objects {
        
        for object in objects {
        
        if let queryLoc = self.currLocation {
        
        var getNearPostsQuery = PFQuery(className: "nearPosts")
        getNearPostsQuery.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId!)!)
        getNearPostsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 50)
        getNearPostsQuery.limit = 200;
        getNearPostsQuery.orderByDescending("createdAt")
        getNearPostsQuery.findObjectsInBackgroundWithBlock({ (objects, error ) -> Void in
        if let objects = objects {
        for object in objects {
        
        self.itemTitles.append(object["itemTitle"] as! (String))
        self.itemDescriptions.append(object["itemDescription"] as! String)
        self.imageFiles.append(object["imageFile"] as! PFFile)
        self.usernames.append(self.users[object["username"] as! String]!)
        self.tableView.reloadData()
        
        }
        }
        })
        self.refresher.endRefreshing()
        
        }
        }
        }
        })
        
        }
        
        
        
        })
        
        */
        /*
        var query = PFQuery(className:"nearPosts")
        if let queryLoc = currLocation {
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 50)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        
                        var getNearPostsQuery = PFQuery(className: "nearPosts")
                        getNearPostsQuery.whereKey("objectId", equalTo: (PFUser.currentUser()?.objectId!)!)
                        getNearPostsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 50)
                        getNearPostsQuery.limit = 200;
                        getNearPostsQuery.orderByDescending("createdAt")
                        getNearPostsQuery.findObjectsInBackgroundWithBlock({ (objects, error ) -> Void in
                            print(getNearPostsQuery)
                            if let objects = objects {
                                for object in objects {
                                    
                                    self.itemTitles.append(object["itemTitle"] as! (String))
                                    self.itemDescriptions.append(object["itemDescription"] as! String)
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    self.usernames.append(self.users[object["username"] as! String]!)
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        })
                        self.refresher.endRefreshing()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        
        }
        }
        
        */

    /*
    func queryForTable() -> PFQuery! {
        let getNearPostsQuery = PFQuery(className: "nearPosts")
    
        getNearPostsQuery.whereKey("username", equalTo: PFUser.currentUser()!.objectId!)
    
        if let queryLoc = currLocation {
            getNearPostsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 50)
            getNearPostsQuery.limit = 200;
            getNearPostsQuery.orderByDescending("createdAt")
            getNearPostsQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        self.itemDescriptions.append(object["itemDescription"] as! String)
                        self.imageFiles.append(object["imageFile"] as! PFFile)
                        self.itemTitles.append(object["itemTitle"] as! String)
                        self.usernames.append(self.users[object["userId"] as! String]!)
                        
                        
                        self.tableView.reloadData()
                        
                        
                    }
                    print(self.users)
                    print(self.itemDescriptions)
                }

            })
        } else {
            /* Decide on how the application should react if there is no location available */
            getNearPostsQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 37.411822, longitude: -121.941125), withinMiles: 10)
            getNearPostsQuery.limit = 200;
            getNearPostsQuery.orderByDescending("createdAt")
        }

        
        return getNearPostsQuery
        
        
    }
*/
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0]
            print(location.coordinate)
            currLocation = location.coordinate
        } else {
            print("Something  didn't work")
        }

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
       override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemTitles.count
        
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    print(self.usernames)
        let cellIdentifier = "BasicCell"
        let myCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! closeOutCell
        
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.postedImage.image = downloadedImage
                
                print(downloadedImage)
            }
        }
let titles = itemTitles[indexPath.row]

        myCell.itemTitle.text = titles
        
        let descriptions = itemDescriptions[indexPath.row]
        
        myCell.itemDescription.text = descriptions
        
        return myCell

    }

     /*
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)

        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
            
        

    }
        /*
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                self.itemDescriptions.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.itemTitles.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                }
                
                
            }
            
            */
            

            
/*
            
            var getNearPostsQuery = PFQuery(className: "nearPosts")
            
            getNearPostsQuery.whereKey("nearPost", equalTo: PFUser.currentUser()!.objectId!)
            
            getNearPostsQuery.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        var nearUser = object["near"] as! String
                        
                        var query = PFQuery(className: "Post")
                        
                        query.whereKey("userId", equalTo: nearUser)
                        
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                            if let objects = objects {
                                
                                for object in objects {
                                    
                                    self.itemDescriptions.append(object["itemDescription"] as! String)
                                    
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    
                                    self.itemTitles.append(object["itemTitle"] as! String)
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                }
                            }
                        })
                    }
                }
            }



        })
        
    
    */
        
       /*
        
            }

*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     func queryForTable() -> PFQuery! {
        let query = PFQuery(className: "post")
        if let queryLoc = currLocation {
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 50)
            query.limit = 200;
            query.orderByDescending("createdAt")
        } else {
            /* Decide on how the application should react if there is no location available */
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 37.411822, longitude: -121.941125), withinMiles: 10)
            query.limit = 200;
            query.orderByDescending("createdAt")
        }
        
        return query
    }
    */

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemDescriptions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("ImagePost", forIndexPath: indexPath) as! cell
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.postedImage.image = downloadedImage
            }
        }
        
        myCell.itemTitle.text = itemTitles[indexPath.row]
        myCell.itemDescription.text = itemDescriptions[indexPath.row]
        
        return myCell
    }
    


    */




}