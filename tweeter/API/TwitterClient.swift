//
//  TwitterClient.swift
//  tweeter
//
//  Created by drishi on 9/27/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL, consumerKey: "qFIop5Itn47DKNfFFWN3QpqW3", consumerSecret: "FuG0pSTIcl3MDpbWarUpHnIkO6LWdHwvPRI9TMlQufuDqE8Ksx")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func homeTimeline(maxId: Int?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var parameters = [String:Int]()
        if let maxId = maxId {
            parameters = ["max_id": maxId]
        }
        get("/1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! [NSDictionary]
            let tweets = Tweet.tweetsFromArray(data: data)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func createTweet(text: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/update.json", parameters: ["status": text], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            let tweet = Tweet(data: data)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func replyToTweet(text: String, inReplyToId: Int?, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/update.json", parameters: ["status": text, "in_reply_to_id": inReplyToId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            let tweet = Tweet(data: data)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func retweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            let tweet = Tweet(data: data)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func unretweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            let tweet = Tweet(data: data)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func like(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            let tweet = Tweet(data: data)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func unlike(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            let tweet = Tweet(data: data)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User)->(), failure: @escaping (Error)->()) {
        get("/1.1/account/verify_credentials.json", parameters: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print ("Account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(data: userDictionary)
            success(user)
            /*
            print("name: \(user.name)")
            print("screename: \(user.screenname)")
            print("profile_url: \(user.profileUrl)")
            print("description: \(user.tagLine)")*/
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //self.currentAccount()
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
                self.loginFailure?(error)
            })
        }) {(error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "tweeter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let string = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token.description)"
            if let url = URL(string: string) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }, failure: { (error: Error!) in
            print("Error: \(error?.localizedDescription) ")
            self.loginFailure?(error)
        })
    }
}
