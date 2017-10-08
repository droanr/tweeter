//
//  ProfileViewController.swift
//  tweeter
//
//  Created by drishi on 10/8/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var inReplyToScreename = ""
    var inReplyToId = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "profileHeader")
        let nibName = UINib(nibName: "profileHeader", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "profileHeader")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchTweetsAndUpdateTable()
    }
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchTweetsAndUpdateTable()
        refreshControl.endRefreshing()
    }
    
    func fetchTweetsAndUpdateTable() {
        TwitterClient.sharedInstance?.homeTimeline(maxId: nil, success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.reloadWithAnimation()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
    func reloadWithAnimation() {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeTweet" {
            let navigationController = segue.destination as! UINavigationController
            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
            composeTweetViewController.delegate = self
            if self.inReplyToScreename != "" {
                composeTweetViewController.inReplyToScreename = inReplyToScreename
            }
            
            if self.inReplyToId != -1 {
                composeTweetViewController.inReplyToId = inReplyToId
            }
        } else if segue.identifier == "tweetDetails" {
            let cell = sender as! TweetsTableViewCell
            let detailsController = segue.destination as! TweetDetailViewController
            detailsController.tweet = cell.tweet
            let indexPath = tableView.indexPath(for: cell)
            detailsController.index = indexPath?.row
            detailsController.delegate = self
        }
    }

}

extension ProfileViewController: TweetsTableViewCellDelegate {
    func callSegueFromCell(inReplyToScreename: String, inReplyToId: Int) {
        self.inReplyToScreename = inReplyToScreename
        self.inReplyToId = inReplyToId
        performSegue(withIdentifier: "composeTweet", sender: self)
    }
}

extension ProfileViewController: TweetDetailsViewControllerDelegate {
    func tweetWithUpdatedData(tweet: Tweet, index: Int) {
        self.tweets[index] = tweet
        self.tableView.reloadData()
    }
}

extension ProfileViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewControllerTweeted(tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        self.inReplyToScreename = ""
        self.inReplyToId = -1
        reloadWithAnimation()
    }
    
    func composeTweetViewControllerCancelled() {
        self.inReplyToId = -1
        self.inReplyToScreename = ""
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "profileHeader") as? ProfileTableHeaderView
        header?.user = User.currentUser
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}



