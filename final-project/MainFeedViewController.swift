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
    
    // MARK: outlet
    @IBOutlet weak var mainFeedTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.posts = MockData.sharedInstance.getAllPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        self.mainFeedTableView.delegate = self
        self.mainFeedTableView.dataSource = self
        self.mainFeedTableView.estimatedRowHeight = 100
        self.mainFeedTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetail" {
            if let indexPath = self.mainFeedTableView.indexPathForSelectedRow {
                let currentPost = self.posts?.postArray[indexPath.row]
                let controller = segue.destination as! PostDetailViewController
                controller.titleText = currentPost?.title
                controller.itemDescription = currentPost?.description
                controller.longitude = currentPost?.longitude
                controller.latitude = currentPost?.latitude
            }
        }
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
        return cell
    }
}

