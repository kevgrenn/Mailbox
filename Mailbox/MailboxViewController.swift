//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by kevin grennan on 2/15/16.
//  Copyright © 2016 kevin grennan. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var mailScroll: UIScrollView!
    @IBOutlet weak var singleMessage: UIImageView!
    @IBOutlet weak var rescheduleOverlay: UIImageView!
    @IBOutlet weak var feed: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var firstMessageHolder: UIView!
    @IBOutlet weak var listOverlay: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var inboxView: UIView!
    
    
    var initialCenter: CGPoint!
    var laterIconInitialCenter: CGPoint!
    var archiveIconInitialCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        mailScroll.contentSize = CGSize(width:320, height:1281)
        laterIcon.alpha = 0
        laterIconInitialCenter = laterIcon.center
        archiveIcon.alpha = 0
        archiveIconInitialCenter = archiveIcon.center
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: "screenEdgeSwiped:")
        edgePan.edges = .Left
        
        view.addGestureRecognizer(edgePan)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        self.singleMessage.center.x = self.firstMessageHolder.center.x
        if(event.subtype == UIEventSubtype.MotionShake){
            UIView.animateWithDuration(0.4, animations: {
                self.feed.center.y = self.feed.center.y + self.firstMessageHolder.bounds.height

                }, completion: {(Bool) -> Void in
                    
            })
        }    }
    
    

    
    func screenEdgeSwiped(recognizer: UIScreenEdgePanGestureRecognizer) {
        let location = recognizer.locationInView(view)
        var translation = recognizer.translationInView(view)
        var velocity = recognizer.velocityInView(view)
    
        if recognizer.state == UIGestureRecognizerState.Began {
            initialCenter = inboxView.center
        } else if recognizer.state == UIGestureRecognizerState.Changed {
            if translation.x >= 0{
            inboxView.center = CGPoint(x: translation.x + initialCenter.x, y: initialCenter.y)
            }
        } else if recognizer.state == UIGestureRecognizerState.Ended{
            if velocity.x <= 0{
                UIView.animateWithDuration(0.4, animations: {
                    self.inboxView.center = self.initialCenter
                })
                
            }else{
                UIView.animateWithDuration(0.4, animations: {
                    self.inboxView.center.x = 450
                    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
                    self.inboxView.addGestureRecognizer(panGestureRecognizer)
                })
                
                
            }
        }
    }
    
    func onCustomPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began {
            initialCenter = inboxView.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            if translation.x <= 0{
                inboxView.center = CGPoint(x: translation.x + initialCenter.x, y: initialCenter.y)
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.x <= 0{
                self.removeInboxPanGesture(self.inboxView, selector: "panGestureRecognizer")
                UIView.animateWithDuration(0.4, animations: {
                    self.inboxView.center.x = 160
                })
                
            }else{
                UIView.animateWithDuration(0.4, animations: {
                    self.inboxView.center = self.initialCenter
                })
                
                
            }
 
        }
    }
    
    
    func removeInboxPanGesture(imageView: UIView, selector: String){
        if let recognizers = imageView.gestureRecognizers {
            for recognizer in recognizers {
                imageView.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    

    @IBAction func listTap(sender: AnyObject) {
        if listOverlay.alpha == 1{
            UIView.animateWithDuration(0.4, animations: {
                self.listOverlay.alpha = 0
                self.completeHideMessage(self)
            })
        }
    }
    @IBAction func rescheduleTap(sender: AnyObject) {
        if rescheduleOverlay.alpha == 1{
            self.rescheduleOverlay.alpha = 0
            self.completeHideMessage(self)
        }
    }
    
    func completeHideMessage(sender:AnyObject){
    UIView.animateWithDuration(0.4, animations: {
    self.feed.center.y = self.feed.center.y - self.firstMessageHolder.bounds.height

    }, completion: {(Bool) -> Void in
    
    })
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            self.inboxView.center.x = 450
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            self.inboxView.addGestureRecognizer(panGestureRecognizer)
        })
    }


    
    @IBAction func panMessage(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began{
            initialCenter = singleMessage.center
        }else if sender.state == UIGestureRecognizerState.Changed{
            singleMessage.center = CGPoint(x: translation.x + initialCenter.x, y: initialCenter.y)
            if translation.x > -60 && translation.x < 0 {
                laterIcon.image = UIImage(named: "later_icon")
                let messageViewPosition = translation.x
                let iconAplha = convertValue(messageViewPosition, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
                laterIcon.alpha = iconAplha
                self.firstMessageHolder.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
            }; if translation.x < 60  && translation.x > 0 {
                archiveIcon.image = UIImage(named: "archive_icon")
                let messageViewPosition = translation.x
                let iconAplha = convertValue(messageViewPosition, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                archiveIcon.alpha = iconAplha
                self.firstMessageHolder.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)

            }; if translation.x < -60{
                laterIcon.image = UIImage(named: "later_icon")
                firstMessageHolder.backgroundColor = UIColor(red: 255/255, green: 213/255, blue: 52/255, alpha: 1)
                laterIcon.center.x = 350 + translation.x
            }; if translation.x < -260{
                laterIcon.image = UIImage(named: "list_icon")
                firstMessageHolder.backgroundColor = UIColor(red: 227/255, green: 180/255, blue: 127/255, alpha: 1)
            }; if translation.x > 60{
                archiveIcon.image = UIImage(named: "archive_icon")
                firstMessageHolder.backgroundColor = UIColor(red: 117/255, green: 208/255, blue: 108/255, alpha: 1)
                archiveIcon.center.x = translation.x - 30
            }; if translation.x > 260{
                archiveIcon.image = UIImage(named: "delete_icon")
                firstMessageHolder.backgroundColor = UIColor(red: 249/255, green: 110/255, blue: 55/255, alpha: 1)
            }
            
        }else if sender.state == UIGestureRecognizerState.Ended{
            if translation.x < 60 && translation.x > -60 {
                UIView.animateWithDuration(0.4, animations: {
                self.singleMessage.center = self.initialCenter
                self.firstMessageHolder.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)                })
            } else if translation.x > 60{
                self.archiveIcon.alpha = 0
                self.archiveIcon.center.x = self.archiveIconInitialCenter.x
                UIView.animateWithDuration(0.4, animations: {
                self.singleMessage.center.x = 600
                    self.completeHideMessage(self)
              
                })
            } else if translation.x < -60 && translation.x > -260{
                UIView.animateWithDuration(0.4, animations: {
                    self.singleMessage.center.x = -600
                })
                UIView.animateWithDuration(0.4, delay: 0.4, options: [], animations: {
                    self.rescheduleOverlay.alpha = 1
                    }, completion: nil)
                self.laterIcon.alpha = 0
                self.laterIcon.center.x = self.laterIconInitialCenter.x
            }else if translation.x < -260 {
                UIView.animateWithDuration(0.4, animations: {
                    self.singleMessage.center.x = -600
                })
                UIView.animateWithDuration(0.4, delay: 0.4, options: [], animations: {
                self.listOverlay.alpha = 1
                }, completion: nil)
                self.laterIcon.alpha = 0
                self.laterIcon.center.x = self.laterIconInitialCenter.x
            }
        }
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
