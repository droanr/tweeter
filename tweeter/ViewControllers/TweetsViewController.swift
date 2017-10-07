	//
//  TweetsViewController.swift
//  tweeter
//
//  Created by drishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    var inReplyToScreename = ""
    var inReplyToId = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchTweetsAndUpdateTable()
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
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchTweetsAndUpdateTable()
        refreshControl.endRefreshing()
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
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

extension TweetsViewController: ComposeTweetViewControllerDelegate {
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

extension TweetsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = self.tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
                isMoreDataLoading = true
                let maxId = self.tweets[self.tweets.count-1].id
                TwitterClient.sharedInstance?.homeTimeline(maxId: maxId, success: { (tweets: [Tweet]) in
                    self.tweets = self.tweets + tweets
                    self.tableView.reloadData()
                    self.isMoreDataLoading = false
                }, failure: { (error:Error) in
                    print("Error: \(error.localizedDescription)")
                })
            }
        }
    }
}

extension TweetsViewController: TweetsTableViewCellDelegate {
    func callSegueFromCell(inReplyToScreename: String, inReplyToId: Int) {
        self.inReplyToScreename = inReplyToScreename
        self.inReplyToId = inReplyToId
        performSegue(withIdentifier: "composeTweet", sender: self)
    }
}

extension TweetsViewController: TweetDetailsViewControllerDelegate {        
    func tweetWithUpdatedData(tweet: Tweet, index: Int) {
        self.tweets[index] = tweet
        self.tableView.reloadData()
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
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
}
