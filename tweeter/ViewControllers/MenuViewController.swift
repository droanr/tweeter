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
    private var tweetsHomeNavigationViewController: UINavigationController!
    private var tweetsMentionsNavigationViewController: UINavigationController!
    private var profileNavigationViewController: UINavigationController!
    var menuOptions = ["Home Timeline", "Mentions", "Profile"]
    var viewControllers: [UIViewController] = []
    var hamburgerMenuViewController: HamburgerMenuViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsHomeNavigationViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let tweetsViewController = tweetsHomeNavigationViewController.topViewController as! TweetsViewController
        tweetsViewController.endpoint = "home_timeline"
        viewControllers.append(tweetsHomeNavigationViewController)
        tweetsMentionsNavigationViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let tweetsMentionsViewController = tweetsMentionsNavigationViewController.topViewController as! TweetsViewController
        tweetsMentionsViewController.endpoint = "mentions"
        viewControllers.append(tweetsMentionsNavigationViewController)
        profileNavigationViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        //let profileViewController = profileNavigationViewController.topViewController as! ProfileViewController
        viewControllers.append(profileNavigationViewController)
        hamburgerMenuViewController.contentViewController = tweetsHomeNavigationViewController
        self.tableView.reloadData()
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
