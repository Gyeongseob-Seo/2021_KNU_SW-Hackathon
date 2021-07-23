//
//  ChatViewController.swift
//  ChattingApp
//
//  Created by 윤경록 on 23/07/2021.
//  Copyright © 2021 윤경록. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore

struct Message {
    let sender: String
    let body: String

}

class ChatViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var MessageTableView: UITableView!
    let db = Firestore.firestore()
    @IBOutlet weak var MessageTextField: UITextField!
    
    var messages: [Message] = []
    func init_data(){
        
        var m1 = Message(sender: "Hom",body: "Hi")
        messages.append(m1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MessageTableView.dataSource = self
        self.MessageTableView.delegate = self
        MessageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        /*
        MessageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        init_data()*/
        self.MessageTableView.reloadData()
        print("RoadSuccess")
        loadMessages()
        print("Enter Chat View")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {

        if let messageBody = MessageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Success save data ")

                    DispatchQueue.main.async {
                        self.MessageTextField.text = ""
                    }
                }
            }
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func loadMessages() {
        print("Function load Message - entered")

        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in

                self.messages = []

                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        snapshotDocuments.forEach { (doc) in
                            let data = doc.data()
                            if let sender = data["sender"] as? String, let body = data["body"] as? String {
                                self.messages.append(Message(sender: sender, body: body))


                                DispatchQueue.main.async {
                                    self.MessageTableView.reloadData()
                                    self.MessageTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: false)
                                }

                            }
                        }
                    }
                }
            }
        print(messages)
        print("Function - loadmessage - success")
    }
    
   
}

extension ChatViewController {

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          print("Function tableview 2nd - enter")
          let message = messages[indexPath.row]

          let messageCell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell


          if message.sender == Auth.auth().currentUser?.email {
              messageCell.LeftImageView.isHidden = true
              messageCell.RightImageView.isHidden = false
            messageCell.MessageLabel.backgroundColor = UIColor.init(displayP3Red: 196/255, green: 139/255, blue: 58/255, alpha: 1)
              messageCell.MessageLabel.textColor = UIColor.white
          } else {
              messageCell.LeftImageView.isHidden = false
              messageCell.RightImageView.isHidden = true
            messageCell.MessageLabel.backgroundColor = UIColor.init(displayP3Red: 121/255, green: 121/255, blue: 119/255, alpha: 1)
              messageCell.MessageLabel.textColor = UIColor.white
          }

          messageCell.MessageLabel.text = message.body
          print("Function tableview 2nd - end")
          return messageCell
      }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return messages.count
         }


}

