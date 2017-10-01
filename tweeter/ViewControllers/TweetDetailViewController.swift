//
//  TweetDetailViewController.swift
//  tweeter
//
//  Created by drishi on 9/30/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var inReplyToIcon: UIImageView!
    @IBOutlet weak var inReplyToLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    var tweet: Tweet! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpTouchRecognizers()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        userImage.setImageWith((tweet.user?.profileUrl)!)
        userName.text = tweet.user?.name
        userHandle.text = "@" + (tweet.user?.screenname)!
        tweetTime.text = tweet.shortStyleTimestamp
        tweetLabel.text = tweet.text
        retweetCount.text = "\(tweet.retweetCount)"
        likeCount.text = "\(tweet.favoritesCount)"
        
        if tweet.favorited == true {
            likeImage.image = UIImage.init(named: "like_selected")
        }
        
        if tweet.retweeted == true {
            retweetImage.image = UIImage.init(named: "retweet_selected")
        }
        
        if let retweeted_status = tweet.retweetedStatus {
            inReplyToLabel.isHidden = false
            inReplyToIcon.isHidden = false
            retweetedIcon.isHidden = true
            let text = (retweeted_status.user?.name!)! + " retweeted"
            inReplyToLabel.text = text
        } else if let screenName =  tweet.inReplyToScreename {
            inReplyToLabel.isHidden = false
            inReplyToIcon.isHidden = true
            retweetedIcon.isHidden = false
            let text = "In reply to " + screenName
            inReplyToLabel.text = text
        } else {
            inReplyToLabel.isHidden = true
            inReplyToIcon.isHidden = true
            retweetedIcon.isHidden = true
        }
    }
    
    func setUpTouchRecognizers() {
        let replyToRecognizer = UITapGestureRecognizer(target: self, action: #selector(onReplyTo(tapGestureRecognizer:)))
        replyImage.isUserInteractionEnabled = true
        replyImage.addGestureRecognizer(replyToRecognizer)
        
        let likeRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLike(tapGestureRecognizer:)))
        likeImage.isUserInteractionEnabled = true
        likeImage.addGestureRecognizer(likeRecognizer)
        
        let retweetRecognizer = UITapGestureRecognizer(target: self, action: #selector(onRetweet(tapGestureRecognizer:)))
        retweetImage.isUserInteractionEnabled = true
        retweetImage.addGestureRecognizer(retweetRecognizer)
    }
    
    @objc func onLike(tapGestureRecognizer: UITapGestureRecognizer) {
        if self.tweet.favorited == true {
            TwitterClient.sharedInstance?.unlike(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.favorited = false
                self.likeImage.image = UIImage.init(named: "like")
                let count = Int((self.likeCount.text)!)! - 1
                self.likeCount.text = "\(count)"
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.like(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.favorited = true
                self.likeImage.image = UIImage.init(named: "like_selected")
                let count = Int((self.likeCount.text)!)! + 1
                self.likeCount.text = "\(count)"
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    @objc func onReplyTo(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "composeTweet", sender: self)
    }

    @objc func onRetweet(tapGestureRecognizer: UITapGestureRecognizer) {
        if self.tweet.retweeted == true {
            TwitterClient.sharedInstance?.unretweet(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.retweeted = false
                self.retweetImage.image = UIImage.init(named: "retweet")
                let count = Int((self.retweetCount.text)!)! - 1
                self.retweetCount.text = "\(count)"
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.retweeted = true
                self.retweetImage.image = UIImage.init(named: "retweet_selected")
                let count = Int((self.retweetCount.text)!)! + 1
                self.retweetCount.text = "\(count)"
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeTweet" {
            let navigationController = segue.destination as! UINavigationController
            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
            composeTweetViewController.inReplyToScreename = tweet.user?.screenname
            composeTweetViewController.inReplyToId = tweet.id
        }
    }
    

}
