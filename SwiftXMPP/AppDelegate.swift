
//
//  AppDelegate.swift
//  SwiftXMPP
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate {
    
    var window: UIWindow?
    var viewController: BuddyListViewController?
    var password: String = ""
    var isOpen: Bool = false
    var curXmppStream: XMPPStream?
     var chatDelegate: ChatDelegate?
     var messageDelegate: MessageDelegate?
    var loginServer: String = ""
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
        self.connect()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func setupStream() {
        print("setupStream")
        curXmppStream = XMPPStream()
        
        curXmppStream!.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }

    func connect() -> Bool {
        print("connecting")
        setupStream()
    
        //NSUserDefaults.standardUserDefaults().setValue("8grabows@jabber.mafiasi.de", forKey: "userID")
        let b = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        print("user defaults: " + "\(b)") //Optional("user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110")
        
        let jabberID: String? = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        print("jabberID=\(jabberID)") //Optional("user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110")
        let myPassword: String? = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        print("myPassword=\(myPassword)") //Optional("password1")
        let server: String? = NSUserDefaults.standardUserDefaults().stringForKey("loginServer")
        print("server=\(server)") //Optional("192.168.1.110")
        if server != nil{
            loginServer = server!
        }
//        curXmppStream!.hostName = "localhost"
        curXmppStream!.hostName = server
//        curXmppStream?.myJID.domain = "localhost"
        //curXmppStream!.hostPort = 5222
        //curXmppStream!.hostPort = 7070
        
        print("curXmppStream=\(curXmppStream)") //Optional(<XMPPStream: 0x7fd0f8feb950>)
        
        if let stream = curXmppStream {
            if !stream.isDisconnected() {
                return true
            }
            
            if jabberID == nil || myPassword == nil{
                print("no jabberID set:" + "\(jabberID)")
                print("no password set:" + "\(myPassword)")
                return false
            }
            
            stream.myJID = XMPPJID.jidWithString(jabberID)
            password = myPassword!
            
            do{
                try stream.connectWithTimeout(XMPPStreamTimeoutNone)
            }catch let error{
                let alert = UIAlertController(title: "Alert", message: "Cannot connect to : \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
            
        }
        return true
    }
    
    func disconnect() {
        goOffline()
        curXmppStream!.disconnect()
        print("disconnecting")
    }
    
    func goOffline() {
        print("goOffline")
        let presence = XMPPPresence(type: "unavailable")
        curXmppStream!.sendElement(presence)
    }
    
    func goOnline() {
        let presence = XMPPPresence()
        //        let presence = XMPPPresence(type: "away")
        curXmppStream!.sendElement(presence)
    }
    
    func xmppStreamDidConnect(sender: XMPPStream) {
        print("xmppStreamDidConnect")
        isOpen = true
        do{
            try curXmppStream!.authenticateWithPassword(password)
            print("authentification successful")
        }catch let error{
            print("authentification error=\(error)")
        }
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream) {
        print("didAuthenticate")
        
        print("sender.isAuthenticated()=\(sender.isAuthenticated())") //true
        print("sender.myJID=\(sender.myJID)") //user-7aa7e3c3-bf8f-46e1-8cbe-3a5aad6e9dfb@192.168.1.110/8f0a93af
        print("sender.myJID.domain=\(sender.myJID.domain)") //192.168.1.110
        print("sender.myJID.domainJID()=\(sender.myJID.domainJID())") //192.168.1.110
        
        goOnline()
    }

    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!)
    {
        print("didNotAuthenticate")
        print("error=\(error)") //error=<failure xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><not-authorized/></failure>
        print("sender.myJID=\(sender.myJID)") //user-7aa7e3c3-bf8f-46e1-8cbe-3a5aad6e9dfb@192.168.1.110
        print("sender.myJID.domain=\(sender.myJID.domain)") //192.168.1.110
        print("sender.myJID.domainJID()=\(sender.myJID.domainJID())") //192.168.1.110
    }
    
    //when receive add friend request
    func xmppStream(sender: XMPPStream!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!)
    {
        print("didReceivePresenceSubscriptionRequest")
        print("sender=\(sender), presence=\(presence)")
    }
    
    //when send new message to friend
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!) {
        print("Did send message \(message)") //<message type="chat" to="user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110"><body>send to XMPP client</body></message>
    }
    
    //when receive new message from friend
    func xmppStream(sender: XMPPStream?, didReceiveMessage: XMPPMessage?) {
        print("didReceiveMessage")
        //print("didReceiveMessage=\(didReceiveMessage)")

        if let message:XMPPMessage = didReceiveMessage {
            print("message: \(message)") //<message xmlns="jabber:client" type="chat" id="purple534f8ea6" to="user-7aa7e3c3-bf8f-46e1-8cbe-3a5aad6e9dfb@192.168.1.110/f42314b" from="user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110/licrifandeMacBook-Pro"><body>from Adium to SwiftXMPP</body></message>
            if let msg: String = message.elementForName("body")?.stringValue() {
                if let from: String = message.attributeForName("from")?.stringValue() {
                    let m: NSMutableDictionary = [:]
                    m["msg"] = msg
                    m["sender"] = from
                    print("messageReceived")
                    if messageDelegate != nil
                    {
                        messageDelegate!.newMessageReceived(m)
                    }
                }
            } else { return }
        }
    }
    
    //when receive friend become online
    func xmppStream(sender: XMPPStream?, didReceivePresence: XMPPPresence?) {
        print("didReceivePresence=\(didReceivePresence)") //Optional(<presence xmlns="jabber:client" from="user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110/licrifandeMacBook-Pro" to="user-7aa7e3c3-bf8f-46e1-8cbe-3a5aad6e9dfb@192.168.1.110/b62e5746"><c xmlns="http://jabber.org/protocol/caps" node="http://pidgin.im/" hash="sha-1" ver="DdnydQG7RGhP9E3k9Sf+b+bF0zo="/><x xmlns="vcard-temp:x:update"><photo>aa6e432351442c73d99ca484cd91abc96b1c7bed</photo></x></presence>)

        if let presence = didReceivePresence {
            let presenceType = presence.type()
            let myUsername = sender?.myJID.user
            let presenceFromUser = presence.from().user
            
         print(chatDelegate)
            if chatDelegate != nil {
                if presenceFromUser != myUsername {
                    if presenceType == "available" {
                        chatDelegate?.newBuddyOnLine("\(presenceFromUser)" + "@" + "\(loginServer)")
                    } else if presenceType == "unavailable" {
                        chatDelegate?.buddyWentOffline("\(presenceFromUser)" + "@" + "\(loginServer)")
                    }
                }
            }
            print(presenceType)
        }
    }
    
//    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
//        print("Did receive Roster item")
//    }
    
    
}


