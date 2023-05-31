import UIKit
import FirebaseAuth
import FirebaseFirestore
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    
    
    var messages : [Message] = [
            Message(sender: "1@2.com", body: "Hello"),
            Message(sender: "a@b.com", body: "Hey"),
            Message(sender: "1@2.com", body: "What's up")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = K.appName
        navigationItem.hidesBackButton = true
        
        messageTextfield.layer.cornerRadius = 20
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    
    func loadMessages(){
        messages = []
        
        //Get data from firestore
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { querySnapshot, err in
            
            self.messages = []
            if let err = err {
                    print("Error getting documents: \(err)")
                }
            else {
                
                if let snapShotDocuments = querySnapshot?.documents{
                    
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let body = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: sender, body: body)  //This is a object of Message class
                            
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()   //Reload the viewDidLoad()
                                
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        else{
                            
                        }

                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        //Send data to firestore
        if let messageBody = messageTextfield.text,let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField : messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dateField : Date().timeIntervalSince1970
                ])
            { (error) in
                if let e = error{
                    print("There is an error saving data to firestore \(e)")
                }
                else{
                    self.messageTextfield.text = ""
                    print("message save in firestore")
                }
            }
        }
        
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}


extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //This is a message from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.pink)
            cell.label.textColor = UIColor(named: K.BrandColors.cream)
            cell.label.textAlignment = .left
        }
        
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.cream)
            cell.label.textColor = UIColor(named: K.BrandColors.pink)
            cell.label.textAlignment = .right
        }
        
        // Calculate and update the label size dynamically
            let labelSize = cell.label.sizeThatFits(CGSize(width: cell.label.frame.width, height: CGFloat.greatestFiniteMagnitude))
            cell.label.frame.size = labelSize
            
            // Update the cell's height to match the label's height
            cell.frame.size.height = labelSize.height

        return cell
    }
    
}


//This is not nessasary to the application
extension ChatViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
