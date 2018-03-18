//
//  MyPostViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 17/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class MyPostViewController: UIViewController {

    // MARK: Properties
    var posts = [SinglePost]()
    
    // MARK: Outlets
    @IBOutlet weak var myPostTableView: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPostTableView.delegate = self
        myPostTableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.myPostTableView.estimatedRowHeight = 300
        self.myPostTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMyPosts()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private functions
    private func getMyPosts() {
        self.posts = MockData.sharedInstance.getMyPosts().postArray
        DispatchQueue.main.async {
            self.myPostTableView?.reloadData()
        }
    }

}

extension MyPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            posts.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
}

extension MyPostViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPostTableViewCell", for: indexPath) as! MyPostTableViewCell
        
        let currentPost = posts[indexPath.row]
        cell.titleLabel.text = currentPost.title
        let tempImage = MockData.sharedInstance.getItemImage(url: (currentPost.imgURL)!)
        cell.itemImage.image = tempImage
            //resizeImage(image: tempImage, targetSize: CGSize.init(width: self.mainFeedTableView.width, height: self.mainFeedTableView.width))
        cell.userImage.image = MockData.sharedInstance.getUserImage(url: URL(string: "123")!)
        cell.userNameLabel.text = "Andrew Chiu"
        
        // line between table rows
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    // Set fix row height
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 300.0
//    }
}
