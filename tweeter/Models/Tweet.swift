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
    var relativeTimestamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var id: Int?
    
    init(data: NSDictionary) {
        print(data)
        self.id = data["id"] as? Int
        self.text = data["text"] as? String
        self.retweetCount = (data["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (data["favourites_count"] as? Int) ?? 0
        self.user = User(data: (data["user"] as? NSDictionary)!)
        let timestampString = data["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            self.timestamp = formatter.date(from: timestampString)
            self.relativeTimestamp = Tweet.timeAgoSinceDate(date: self.timestamp! as NSDate)
        }
        
    }
    
    class func tweetsFromArray(data: [NSDictionary]) -> [Tweet] {
        var ret = [Tweet]()
        for tweet in data {
            ret.append(Tweet(data: tweet))
        }
        return ret
    }
    
    class func timeAgoSinceDate(date:NSDate) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 1) {
            return "\(components.year!)y"
        } else if (components.month! >= 1) {
            return "\(components.month!)m"
        } else if (components.weekOfYear! >= 1) {
            return "\(components.weekOfYear!)w"
        } else if (components.day! >= 1) {
            return "\(components.day!)d"
        } else if (components.hour! >= 1) {
            return "\(components.hour!)h"
        } else if (components.minute! >= 1) {
            return "\(components.minute!)m"
        } else if (components.second! >= 1) {
            return "\(components.second!)s"
        }
        return ""
    }
    
}
