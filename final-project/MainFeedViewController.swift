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
    var infoPage: UIView? = nil
    
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
        
        addInfoButton()
        addInfoPage()
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
        
        // Set the tool bar hidden after comming back from detail
        self.navigationController?.isToolbarHidden = true
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
    
    // MARK: Private functions
    private func netWorkErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message , preferredStyle: .alert)
        let action = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addInfoButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(changeInfoPage), for: .touchUpInside)
        infoButton.tag = 1
        let barButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func addInfoPage() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        infoPage = UIView(frame: CGRect(x:0, y:self.view.frame.maxY, width: self.view.frame.width, height: self.view.frame.height))
        infoPage?.backgroundColor = UIColor(red:255/255 , green: 255/255, blue: 255/255, alpha: 0.9)
        
        let pageTitle = UILabel(frame: CGRect(x:0, y:height/10, width: width, height: height*2/10))
        pageTitle.numberOfLines = 0
        pageTitle.text = "About"
        pageTitle.textAlignment = .center
        pageTitle.font  = UIFont.boldSystemFont(ofSize: 50)
        infoPage?.addSubview(pageTitle)
        
        let instruction = UILabel(frame: CGRect(x:10, y:height*5/20, width: width-20, height: height*2/3))
        instruction.numberOfLines = 0
        instruction.text = "This is an application that helps people exchange their surplus food and items. Simply tap the add sign in the middle button of the page, then you can start enjoying! Or view the items from others on the main page, if you want it, ask it right away!"
        instruction.font = UIFont.systemFont(ofSize: 20)
        instruction.sizeToFit()
        //        instruction.backgroundColor = nil
        infoPage?.addSubview(instruction)
        
        let dismissButton = UIButton(frame: CGRect(x:width/3, y:height*7/10, width:width/3, height:height/10))
        dismissButton.setTitle("OK", for: .normal)
        dismissButton.setTitleColor(.blue, for: .normal)
        //        dismissButton.backgroundColor = UIColor.darkGray
        dismissButton.tag = 2
        dismissButton.addTarget(self, action: #selector(changeInfoPage), for: .touchUpInside)
        infoPage?.addSubview(dismissButton)
        
        self.view.addSubview(infoPage!)
    }
    
    @objc func changeInfoPage(sender: UIButton!) {
        //        let width = self.view.frame.width
        //        let height = self.view.frame.height
        
        if sender.tag == 2 {
            UIView.animate(withDuration: 0.5, animations: {
                self.infoPage?.frame = CGRect(x:0, y:self.view.frame.maxY, width: (self.infoPage?.frame.width)!, height: (self.infoPage?.frame.height)!)
            }, completion: nil)
        } else if sender.tag == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.infoPage?.frame = CGRect(x:0, y:0, width: (self.infoPage?.frame.width)!, height: (self.infoPage?.frame.height)!)
            }, completion: nil)
        }
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

