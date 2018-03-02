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
//    @IBOutlet weak var mainFeedTableView: UITableView!
    @IBOutlet weak var mainFeedTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.posts = MockData.sharedInstance.getAllPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mainFeedTableView.delegate = self
        self.mainFeedTableView.dataSource = self
        self.mainFeedTableView.estimatedRowHeight = 100
        self.mainFeedTableView.rowHeight = UITableViewAutomaticDimension
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
//        cell.textLabel!.text = object
        cell.descriptionLabel.text = currentPost?.description
        return cell
    }
}

