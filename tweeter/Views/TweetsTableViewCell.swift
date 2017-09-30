//
//  TweetsTableViewCell.swift
//  tweeter
//
//  Created by Droan Rishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    var tweet: Tweet! {
        didSet {
            userImage.setImageWith((tweet.user?.profileUrl)!)
            userName.text = tweet.user?.name
            userHandle.text = "@" + (tweet.user?.screenname)!
            timeLabel.text = tweet.relativeTimestamp
            tweetLabel.text = tweet.text
            retweetCount.text = "\(tweet.retweetCount)"
            likeCount.text = "\(tweet.favoritesCount)"
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
