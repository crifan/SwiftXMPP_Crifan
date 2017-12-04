//
//  LoginViewController.swift
//  SwiftXMPP
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet var loginField: UITextField?
  @IBOutlet var passwordField: UITextField?
  
//  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//      // Custom initialization
//  }

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func login () {
    print("login") //TODO: Test
    print(loginField!.text)
    
    
    if let login = loginField!.text {
      if let passwd = passwordField!.text {
        print("Login: " + "\(loginField!.text)") //Login: Optional("user-ae96618f-3a5c-48a8-a799-9944a4e76ed9@192.168.1.110")
        
        NSUserDefaults.standardUserDefaults().setValue(login, forKey: "userID")
        NSUserDefaults.standardUserDefaults().setValue(passwd, forKey: "userPassword")
        if( login.componentsSeparatedByString("@").count > 1 )
        {
            let loginServer = login.componentsSeparatedByString("@")[1]
        print("server: \(loginServer)") //192.168.1.110
        NSUserDefaults.standardUserDefaults().setValue(loginServer, forKey: "loginServer")
        NSUserDefaults.standardUserDefaults().synchronize()
        }
      }
    }
    
//    if loginField.text && passwordField.text {
//      println("Login: " + "\(loginField.text)") //TODO: Test
//      NSUserDefaults.standardUserDefaults().setObject(loginField.text, forKey: "userID")
//      NSUserDefaults.standardUserDefaults().setObject(passwordField.text, forKey: "userPassword")
//      NSUserDefaults.standardUserDefaults().synchronize()
//    }
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func hideLogin () {
    dismissViewControllerAnimated(true, completion: nil)
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
