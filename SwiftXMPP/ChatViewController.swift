//
//  ChatViewController.swift
//  SwiftXMPP
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageDelegate {
  
  @IBOutlet var messageField: UITextField?
  @IBOutlet var container : UIView!
  @IBOutlet var bottomContainerConstraint : NSLayoutConstraint?
//  var chatWithUser: String = "teste03@local"
  static var chatWithUser: String = ""
  @IBOutlet var tView: UITableView?
  var messages: NSMutableArray = []
  
//  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    // Custom initialization
//  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tView!.dataSource = self
    tView!.delegate = self
    //self.messageField.becomeFirstResponder()
    if #available(iOS 8.0, *) {
        let del = appDelegate()
        del.messageDelegate = self
    } else {
        // Fallback on earlier versions
    }
    messageField!.becomeFirstResponder()
    
    // Do any additional setup after loading the view.
    registerForKeyboardNotifications()
    
  }
  
  func registerForKeyboardNotifications () {
    let nc = NSNotificationCenter.defaultCenter()
    nc.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
    nc.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
  }

  func keyboardWasShown(aNotification: NSNotification) {
    print("wohoo keyboards")
    let constraint = bottomContainerConstraint
    print("before: \(view.constraints)")
    let info: NSDictionary = aNotification.userInfo!
    let kbSize : CGRect = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue
    
    let visualString = "V:[container]-\(kbSize.height)-|"
    
    let newConstraint: NSArray = NSLayoutConstraint.constraintsWithVisualFormat(visualString, options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["container" : container])
    
    view.removeConstraint(constraint!)
    view.addConstraints(newConstraint as NSArray as! [NSLayoutConstraint])
    
    view.updateConstraints()
    
    print("\n after: \(view.constraints)")
    print("old constraint: \(constraint)")
    print("new constraint: \(newConstraint[0])")
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  @IBAction func sendMessage() {
    print("sendMessage")
    
    print("self=\(self)") //<SwiftXMPP.ChatViewController: 0x7feab2f84150>
    
    let messageStr: String = messageField!.text!
    print("messageStr=\(messageStr)")
    if messageStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
      let body = DDXMLElement.elementWithName("body") as! DDXMLElement
      body.setStringValue(messageStr)
      let message = DDXMLElement.elementWithName("message") as! DDXMLElement
      message.addAttributeWithName("type", stringValue: "chat")
//      message.addAttributeWithName("to", stringValue: chatWithUser as String)
        message.addAttributeWithName("to", stringValue: ChatViewController.chatWithUser as String)
      message.addChild(body)
      xmppStream().sendElement(message)
      print("message=\(message)") //<message type="chat" to="user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110"><body>send to XMPP client</body></message>
      messageField!.text = ""
      
      let m: NSMutableDictionary = [:]
      m["msg"] = messageStr
      m["sender"] = "yourself"
//      println("m: \(m) and message: \(messageStr)")

      messages.addObject(m)
      tView!.reloadData()

    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    print("ChatViewController cellForRowAtIndexPath")

    let s = messages.objectAtIndex(indexPath.row) as! NSDictionary
    let cellIdentifier = "MessageCellIdentifier"
    var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
    if !(cell != nil) {
      cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
    }
    
    if let c = cell {
//      println(s)
      c.textLabel!.text = s["msg"] as? String
      c.detailTextLabel!.text = s["sender"] as? String
        if c.detailTextLabel!.text == "yourself"{
//            c.textLabel?.textAlignment = NSTextAlignment.Right
//            c.detailTextLabel?.textAlignment = NSTextAlignment.Right
            c.contentView.backgroundColor = UIColor.yellowColor()
            c.textLabel?.backgroundColor = c.contentView.backgroundColor
            c.detailTextLabel?.backgroundColor = c.textLabel?.backgroundColor
            c.textLabel?.textColor = UIColor.blueColor()
            c.detailTextLabel?.textColor = c.textLabel?.textColor
        }
      c.accessoryType = .None
      c.userInteractionEnabled = false
    }
    
    return cell!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("ChatViewController numberOfRowsInSection")
    print("messages=\(messages)")
    /*
    messages=(
    {
    msg = "send from user1 via SwitfXMPP";
    sender = you;
    },
    {
    msg = "send from Aduim";
    sender = "user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110/licrifandeMacBook-Pro";
    }
    )
    */
    return messages.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    print("ChatViewController numberOfSectionsInTableView")
    return 1
  }
  
  @IBAction func closeChat() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @available(iOS 8.0, *)
  func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
  }
  
    
  func xmppStream () -> XMPPStream {
        return appDelegate().curXmppStream!
  }
  
  func newMessageReceived(messageContent: NSDictionary) {
    print("ChatViewController newMessageReceived")
    print("messageContent=\(messageContent)")
    messages.addObject(messageContent)
    tView!.reloadData()
    let topIndexPath = NSIndexPath(forRow: (messages.count - 1), inSection: 0)
    tView!.scrollToRowAtIndexPath(topIndexPath, atScrollPosition: .Middle, animated: true)
  }

  
  
  
  
  
  
  /*
  // #pragma mark - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
  }
  */

}
