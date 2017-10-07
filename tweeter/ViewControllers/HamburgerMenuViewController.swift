//
//  HamburgerMenuViewController.swift
//  tweeter
//
//  Created by drishi on 10/6/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class HamburgerMenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    var contentViewController: UIViewController! {
        didSet (oldContentViewController) {
            view.layoutIfNeeded()
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: self)
            }
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            UIView.animate(withDuration: 0.3, animations: {
                self.leftMargin.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        if sender.state == .began {
            originalLeftMargin = leftMargin.constant
        } else if sender.state == .changed {
            if velocity.x > 0 {
                leftMargin.constant = originalLeftMargin + translation.x
                //menuViewController.leftMargin.constant = view.frame.width - leftMargin.constant
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 { //opening
                    self.leftMargin.constant = self.view.frame.size.width * 2/3
                    //self.menuViewController.leftMargin.constant = self.leftMargin.constant
                } else {  //closing
                    self.leftMargin.constant = 0
                    //self.menuViewController.leftMargin.constant = self.view.frame.width - self.leftMargin.constant
                }
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
