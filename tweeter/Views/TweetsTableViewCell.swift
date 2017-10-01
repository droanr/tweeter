//
//  TweetsTableViewCell.swift
//  tweeter
//
//  Created by Droan Rishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

@objc protocol TweetsTableViewCellDelegate {
    @objc optional func callSegueFromCell(inReplyToScreename: String, inReplyToId: Int)
}

class TweetsTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    weak var delegate: TweetsTableViewCellDelegate!
    var tweet: Tweet! {
        didSet {
            userImage.setImageWith((tweet.user?.profileUrl)!)
            userImage.layer.borderWidth = 1
            userImage.layer.masksToBounds = false
            userImage.layer.borderColor = UIColor.black.cgColor
            userImage.layer.cornerRadius = userImage.frame.height/2
            userImage.clipsToBounds = true
            userName.text = tweet.user?.name
            userHandle.text = "@" + (tweet.user?.screenname)!
            timeLabel.text = tweet.relativeTimestamp
            tweetLabel.text = tweet.text
            tweetLabel.translatesAutoresizingMaskIntoConstraints = true
            tweetLabel.sizeToFit()
            tweetLabel.isScrollEnabled = false
            tweetLabel.isEditable = false
            retweetCount.text = "\(tweet.retweetCount)"
            likeCount.text = "\(tweet.favoritesCount)"
            if tweet.retweeted == true {
                retweetImage.image = UIImage.init(named: "retweet_selected")
                retweetCount.textColor = UIColor.green
            } else {
                retweetImage.image = UIImage.init(named: "retweet")
                retweetCount.textColor = UIColor.black
            }
            if tweet.favorited == true {
                likeImage.image = UIImage.init(named: "like_selected")
                likeCount.textColor = UIColor.red
            } else {
                likeImage.image = UIImage.init(named: "like")
                likeCount.textColor = UIColor.black
            }
            setUpTouchRecognizers()
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
    
    @objc func onReplyTo(tapGestureRecognizer: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.callSegueFromCell!(inReplyToScreename: (tweet.user?.screenname)!, inReplyToId: tweet.id!)
        }
    }
    
    @objc func onLike(tapGestureRecognizer: UITapGestureRecognizer) {
        if self.tweet.favorited == true {
            TwitterClient.sharedInstance?.unlike(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.favorited = false
                self.transitionChangeImageView(imageView: self.likeImage, imageName: "like")
                let count = Int((self.likeCount.text)!)! - 1
                self.tweet.favoritesCount = count
                self.likeCount.text = "\(count)"
                self.likeCount.textColor = UIColor.black
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.like(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.favorited = true
                self.transitionChangeImageView(imageView: self.likeImage, imageName: "like_selected")
                let count = Int((self.likeCount.text)!)! + 1
                self.likeCount.text = "\(count)"
                self.tweet.favoritesCount = count
                self.likeCount.textColor = UIColor.red
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    func transitionChangeImageView(imageView: UIImageView, imageName: String) {
        UIView.transition(with: imageView,
                          duration:0.25,
                          options: .transitionCrossDissolve,
                          animations: { imageView.image = UIImage.init(named: imageName) },
                          completion: nil)
    }
    
    @objc func onRetweet(tapGestureRecognizer: UITapGestureRecognizer) {
        if self.tweet.retweeted == true {
            TwitterClient.sharedInstance?.unretweet(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.retweeted = false
                self.transitionChangeImageView(imageView: self.retweetImage, imageName: "retweet")
                let count = Int((self.retweetCount.text)!)! - 1
                self.retweetCount.text = "\(count)"
                self.tweet.retweetCount = count
                self.retweetCount.textColor = UIColor.black
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (tweet: Tweet) in
                self.tweet.retweeted = true
                self.transitionChangeImageView(imageView: self.retweetImage, imageName: "retweet_selected")
                let count = Int((self.retweetCount.text)!)! + 1
                self.retweetCount.text = "\(count)"
                self.tweet.retweetCount = count
                self.retweetCount.textColor = UIColor.green
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
