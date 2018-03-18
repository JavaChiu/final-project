//
//  MessageDetailViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 15/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    // MARK: Properties
    var message: Message?
    var userId: Int?
    
    // MARK: Outletes
    @IBOutlet weak var messageTableView: UITableView!    
    @IBOutlet weak var newMessageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setUpToolBar()
        newMessageTextField.delegate = self
        
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        self.messageTableView.estimatedRowHeight = 200
        self.messageTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userId = self.userId {
            getMessage(user1Id: userId, user2Id: 1)
        }
    }

    // MARK: Private functions
    private func getMessage(user1Id: Int, user2Id: Int) {
        self.message = MockData.sharedInstance.getMessageDetail(user1Id: user1Id, user2Id: user2Id)
        
        DispatchQueue.main.async {
            self.messageTableView?.reloadData()
        }
    }
    
    private func setUpToolBar() {
        self.navigationController?.isToolbarHidden = false
        
        var items = [UIBarButtonItem]()
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
//        items.append(UIBarButtonItem(title: "Request", style: .plain, target: self, action: #selector(request)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        
        self.toolbarItems = items
        
    }
}

extension MessageDetailViewController: UITableViewDelegate {
    
}

extension MessageDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message?.messageDetailArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageDetailTableViewCell", for: indexPath) as! MessageDetailTableViewCell
        
        let currentMessage = message?.messageDetailArray[indexPath.row]
        //        cell.titleLabel.text = currentPost.title
        cell.messageLabel.text = currentMessage?.message
        cell.dateLabel.text = currentMessage?.dateTime
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if (indexPath.row)%2 == 1 {
            cell.userImage?.image = UIImage(named: "profile_girl")
        }
        
        return cell
    }
    
}

extension MessageDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
