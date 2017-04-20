//
//  ViewController.swift
//  Text
//
//  Created by Admin on 14/04/2017.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SettingsViewControllerDelegate{
    
    // MARK: Constants
    fileprivate struct Constants {
        static let MessagesSection: Int = 0;
        static let MessageCellIdentifier: String = "LGChatController.Constants.MessageCellIdentifier"
    }
    
    // MARK: Private Properties
    fileprivate let sizingCell = ChatMessageTableViewCell()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var opponentBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet var InputView: UIView!
    
    
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var shareBtn: UIButton!
    @IBOutlet var settingsBtn: UIButton!
    
    
    // MARK: Public Properties
    
    /*!
     Use this to set the messages to be displayed
     */
    var messages: [ChatMessage] = []
    /*!
     Use this to detect user or opponent
     */
    var isUser = Bool()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        setupKeyboard()
        setupUI()
        
        isUser = true
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(ChatMessageTableViewCell.classForCoder(), forCellReuseIdentifier: "identifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeName() {
        userBtn.setTitle(ConstantsName.userName, for: .normal)
        opponentBtn.setTitle(ConstantsName.opponentName, for: .normal)
    }

    //MARK: Setup UI
    func setupUI() {
        
        sendBtn.layer.cornerRadius = 10
        textField.layer.cornerRadius = 10
        
        createBtn.layer.cornerRadius = 10
        editBtn.layer.cornerRadius = 10
        shareBtn.layer.cornerRadius = 10
        settingsBtn.layer.cornerRadius = 10
    }
    
    func changeUI() {
        if isUser{
            InputView.backgroundColor = UIColor(red: 99/255, green: 248/255, blue: 152/255, alpha: 0.5)
            sendBtn.setTitleColor(UIColor(red: 99/255, green: 248/255, blue: 152/255, alpha: 1), for: .normal)
        }else{
            InputView.backgroundColor = UIColor(red: 255/255, green: 92/255, blue: 142/255, alpha: 0.5)
            sendBtn.setTitleColor(UIColor(red: 255/255, green: 92/255, blue: 142/255, alpha: 1), for: .normal)
        }
        
    }
    
    //MARK: Button Action
    @IBAction func onSend(_ sender: Any) {
        if textField.text!.characters.count > 0 {
            var newMessage = ChatMessage(content: textField.text!, sentBy: .User)
            if isUser {
                newMessage = ChatMessage(content: textField.text!, sentBy: .User)
            }else{
                newMessage = ChatMessage(content: textField.text!, sentBy: .Opponent)
            }
            
            let shouldSendMessage = true
            if shouldSendMessage {
                self.addNewMessage(newMessage)
            }
            textField.text = ""
            self.view.endEditing(true)
        }
        
    }
    
    @IBAction func onUser(_ sender: Any) {
        isUser = true
        changeUI()
    }
    
    @IBAction func onOpponent(_ sender: Any) {
        isUser = false
        changeUI()
    }
    
    @IBAction func onCreate(_ sender: Any) {
    }
    
    @IBAction func onEdit(_ sender: Any) {
        if (self.tableView.isEditing) {
            editBtn.setTitle("EDIT", for: .normal)
            self.tableView.setEditing(false, animated: true)
        } else {
            editBtn.setTitle("DONE", for: .normal)
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func onShare(_ sender: Any) {
        let text = "I want to share this video to social."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onSettings(_ sender: Any) {
        let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsVC.delegate = self
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    // MARK: Tap Gesture
    @IBAction func viewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK: New messages
    func addNewMessage(_ message: ChatMessage) {
        messages += [message]
        tableView.reloadData()
        self.scrollToBottom()
//        self.delegate?.chatController?(self, didAddNewMessage: message)
    }
    
    // MARK: Scrolling
    fileprivate func scrollToBottom() {
        if messages.count > 0 {
            var lastItemIdx = self.tableView.numberOfRows(inSection: Constants.MessagesSection) - 1
            if lastItemIdx < 0 {
                lastItemIdx = 0
            }
            let lastIndexPath = IndexPath(row: lastItemIdx, section: Constants.MessagesSection)
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let padding: CGFloat = 10.0
        sizingCell.bounds.size.width = self.view.bounds.width
        let height = self.sizingCell.setupWithMessage(messages[indexPath.row]).height + padding;
        return height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
//            textField.resignFirstResponder()
        }
    }
    
    //MARK:UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! ChatMessageTableViewCell
        let message = self.messages[indexPath.row]
        cell.setupWithMessage(message)
        cell.isUserInteractionEnabled = true
        return cell;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.messages.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.tableView.isEditing {
            return true
        }else {
            return false
        }
    }
    
    //MARK: Keyboard
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        inputViewBottomConstraint.constant = (keyboardSize?.height)!
        
    }
    
    //MARK: UITextfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

