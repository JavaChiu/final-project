//
//  MainFeedViewController.swift
//  final-project-mock-up
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class MainFeedViewController: UIViewController {
    // MARK: Properties
    var posts = [SinglePost]()
    var infromedNetworkStatus: Bool = false
    
    // MARK: Outlet and Actions
    @IBOutlet weak var mainFeedTableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        self.mainFeedTableView.delegate = self
        self.mainFeedTableView.dataSource = self
//        self.mainFeedTableView.estimatedRowHeight = 300
//        self.mainFeedTableView.rowHeight = UITableViewAutomaticDimension

        // Update firebase login
        if let token = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    ErrorHandler.showError(for: error)
                    return
                }
                SharedNetworking.shared.firebaseID = user!.uid
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.posts = MockData.sharedInstance.getAllPost()
        SharedNetworking.shared.getFeed() { posts in
            self.posts = posts
            
            // add mock data
            self.posts.append(MockData.sharedInstance.getAllPost().postArray)

            DispatchQueue.main.async {
                // Update any views with the newly downloaded news data
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.mainFeedTableView?.reloadData()
            }
        }
        //        getMainFeed(url: WebService.mainFeed.rawValue)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetail" {
            if let indexPath = self.mainFeedTableView.indexPathForSelectedRow {
                let currentPost = self.posts[indexPath.row]
                let controller = segue.destination as! PostDetailViewController
                controller.titleText = currentPost.title
                controller.itemDescription = currentPost.description
                controller.longitude = currentPost.longitude
                controller.latitude = currentPost.latitude
                controller.date = currentPost.eventTime?.dateTimeString()
//                controller.itemImage = MockData.sharedInstance.getItemImage(url: (currentPost?.imgURL)!)
//                controller.address = currentPost?.pickupAddress
//                controller.date = currentPost?.date
//                controller.userName = (currentPost?.user.userName)!
//                controller.userImage = MockData.sharedInstance.getUserImage(url: URL(string: "123")!)
            }
        }
    }
    
    // MARK: private functions
    
//    private func getMainFeed(url: String) {
//        do {
//            try SharedNetworking.shared.getMainFeed(url: url) { (posts) in
//                self.posts = posts
//
//                DispatchQueue.main.async {
//                    // Update any views with the newly downloaded news data
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    self.mainFeedTableView?.reloadData()
//                }
//            }
//        } catch NetWorkError.noConnection {
//            if !self.infromedNetworkStatus {
//                self.netWorkErrorAlert(message: "You seem to be offline")
//                self.infromedNetworkStatus = true
//            }
//        } catch NetWorkError.invalidURL {
//            self.netWorkErrorAlert(message: "There's an error in URL")
//        } catch {
//            print(Error.self)
//        }
//    }
    
    private func netWorkErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message , preferredStyle: .alert)
        let action = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // resize in order to make the image fit table cell
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension MainFeedViewController: UITableViewDelegate {
    
}

extension MainFeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainFeedCell", for: indexPath) as! MainFeedTableViewCell
        
        let currentPost = posts[indexPath.row]
        cell.titleLabel.text = currentPost.title
//        let tempImage = MockData.sharedInstance.getItemImage(url: (currentPost?.imgURL)!)
//        cell.itemImage.image = resizeImage(image: tempImage, targetSize: CGSize.init(width: self.mainFeedTableView.width-100, height: self.mainFeedTableView.width-100))
//        cell.userImage.image = MockData.sharedInstance.getUserImage(url: URL(string: "123")!)
//        cell.userName.text = currentPost?.user.userName
        
        // line between table rows
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    // Set fix row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 300.0
    }
}

