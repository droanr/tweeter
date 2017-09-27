//
//  Tweet.swift
//  tweeter
//
//  Created by drishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import Foundation
import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(data: NSDictionary) {
        self.text = data["text"] as? String
        self.retweetCount = (data["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (data["favourites_count"] as? Int) ?? 0
        
        let timestampString = data["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            self.timestamp = formatter.date(from: timestampString)
        }
    }
    
    class func tweetsFromArray(data: [NSDictionary]) -> [Tweet] {
        var ret = [Tweet]()
        for tweet in data {
            ret.append(Tweet(data: tweet))
        }
        return ret
    }
    
    
}
