//
//  MessageViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 15/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    // MARK: Properties
    var messageOverview: MessageOverview?

    // MARK: Outlets
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        self.navigationController?.isToolbarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMessageOverview()
    }
    
    // MARK: - Navigation

    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageDetail" {
            if let indexPath = self.messageTableView.indexPathForSelectedRow {
                let currentPost = self.messageOverview?.messageOverViewArray[indexPath.row]
                let controller = segue.destination as! MessageDetailViewController
                controller.userId = currentPost?.user.id
            }
        }
    }
 
    
    // MARK: Private functions
    private func getMessageOverview() {
        self.messageOverview = MockData.sharedInstance.getMessageOverview()
        
        DispatchQueue.main.async {
            self.messageTableView?.reloadData()
        }
    }

}

extension MessageViewController: UITableViewDelegate {
    
}

extension MessageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageOverview?.messageOverViewArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell", for: indexPath) as! MessageTableViewCell
        
        let currentMessageOverview = messageOverview?.messageOverViewArray[indexPath.row]
//        cell.titleLabel.text = currentPost.title
        cell.userNameLabel.text = currentMessageOverview?.user.userName
        cell.shortMessageLabel.text = currentMessageOverview?.shortMessage
        cell.dateLabel.text = currentMessageOverview?.dateTime
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
}
