//
//  ComposeTweetViewController.swift
//  tweeter
//
//  Created by drishi on 9/30/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    @objc optional func composeTweetViewController(tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    weak var delegate: ComposeTweetViewControllerDelegate?
    var user: User!
    var inReplyToScreename: String?
    var inReplyToId: Int?
    var placeholder = "What's happening?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.currentUser
        setUpUserDetails()
        setUpComposeTextView()
    }
    
    func setUpUserDetails() {
        userImage.setImageWith(user.profileUrl!)
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        userName.text = user.name
        userHandle.text = "@" + user.screenname!
        characterCount.text = "0"
    }
    
    func setUpComposeTextView() {
        composeTextView.delegate = self
        composeTextView.text = placeholder
        composeTextView.becomeFirstResponder()
        if let inReplyToScreename = inReplyToScreename {
            composeTextView.text = "@" + inReplyToScreename
            characterCount.text = composeTextView.text.characters.count.description
        } else {
            composeTextView.textColor = UIColor.lightGray
            composeTextView.selectedTextRange = composeTextView.textRange(from: composeTextView.beginningOfDocument, to: composeTextView.beginningOfDocument)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if composeTextView.text.characters.count > 0 && composeTextView.textColor != UIColor.lightGray {
            if let inReplyToId = inReplyToId {
                TwitterClient.sharedInstance?.replyToTweet(text: composeTextView.text, inReplyToId: inReplyToId, success: { (tweet: Tweet) in
                    self.delegate?.composeTweetViewController!(tweet: tweet)
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
                })
            } else {
                TwitterClient.sharedInstance?.createTweet(text: composeTextView.text, success: { (tweet: Tweet) in
                    self.delegate?.composeTweetViewController!(tweet: tweet)
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
                })
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeTweetViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text?.isEmpty)! {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            self.characterCount.text = "0"
        } else {
            self.characterCount.text = textView.text.characters.count.description   
        }
    }
}
