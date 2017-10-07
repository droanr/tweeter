//
//  MenuViewController.swift
//  tweeter
//
//  Created by drishi on 10/7/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var tweetsNavigationViewController: UIViewController!
    var menuOptions = ["HomeTimeline", "Profile", "Mentions"]
    var viewControllers: [UIViewController] = []
    var hamburgerMenuViewController: HamburgerMenuViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavigationViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        //let tweetsViewController = nav.topViewController as! TweetsViewController
        viewControllers.append(tweetsNavigationViewController)
        hamburgerMenuViewController.contentViewController = tweetsNavigationViewController
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuOptionsCell") as! MenuOptionsTableViewCell
        cell.optionName = menuOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerMenuViewController.contentViewController = viewControllers[indexPath.row]
    }
}
