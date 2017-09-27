//
//  User.swift
//  tweeter
//
//  Created by drishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagLine: String?
    var dictionary: NSDictionary?
    
    init(data: NSDictionary) {
        self.name = data["name"] as? String
        self.screenname = data["screen_name"] as? String
        let profileUrlString = data["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            self.profileUrl = URL(string: profileUrlString)
        }
        self.tagLine = data["description"] as? String
        self.dictionary = data
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    let user = User(data: dictionary)
                    _currentUser = user
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
