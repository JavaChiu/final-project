//
//  MainFeedViewController.swift
//  final-project-mock-up
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController {
    // MARK: properties
    var posts: Posts?
    var infromedNetworkStatus: Bool = false
    
    // MARK: outlet
    @IBOutlet weak var mainFeedTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.posts = MockData.sharedInstance.getAllPost()
//        getMainFeed(url: WebService.mainFeed.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        self.mainFeedTableView.delegate = self
        self.mainFeedTableView.dataSource = self
        self.mainFeedTableView.estimatedRowHeight = 100
        self.mainFeedTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetail" {
            if let indexPath = self.mainFeedTableView.indexPathForSelectedRow {
                let currentPost = self.posts?.postArray[indexPath.row]
                let controller = segue.destination as! PostDetailViewController
                controller.titleText = currentPost?.title
                controller.itemDescription = currentPost?.description
//                controller.longitude = currentPost?.longitude
//                controller.latitude = currentPost?.latitude
            }
        }
    }
    
    // MARK: private functions
    
    private func getMainFeed(url: String) {        
        do {
            try SharedNetworking.sharedInstance.getMainFeed(url: url) { (posts) in
                self.posts = posts
                
                DispatchQueue.main.async {
                    // Update any views with the newly downloaded news data
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.mainFeedTableView?.reloadData()
                }
            }
        } catch NetWorkError.noConnection {
            if !self.infromedNetworkStatus {
                self.netWorkErrorAlert(message: "You seem to be offline")
                self.infromedNetworkStatus = true
            }
        } catch NetWorkError.invalidURL {
            self.netWorkErrorAlert(message: "There's an error in URL")
        } catch {
            print(Error.self)
        }
    }
    
    private func netWorkErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message , preferredStyle: .alert)
        let action = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainFeedViewController: UITableViewDelegate {
    
}

extension MainFeedViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.postArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainFeedCell", for: indexPath) as! MainFeedTableViewCell
        
        let currentPost = posts?.postArray[indexPath.row]
        cell.titleLabel.text = currentPost?.title
        cell.descriptionLabel.text = currentPost?.description
        return cell
    }
}

