//
//  ComposeViewController.swift
//  Mailbox
//
//  Created by kevin grennan on 2/20/16.
//  Copyright © 2016 kevin grennan. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet var bgView: UIView!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    self.emailField.becomeFirstResponder()
        UIView.animateWithDuration(4, animations: {
        self.bgView.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.5)
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
