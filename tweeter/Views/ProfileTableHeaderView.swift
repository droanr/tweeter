//
//  ProfileTableHeaderView.swift
//  tweeter
//
//  Created by drishi on 10/8/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class ProfileTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        user = User.selectedUser
        backgroundImage.setImageWith(user.backgroundImageUrl!)
        profileImage.setImageWith(user.profileUrl!)
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        userName.text = user.name
        userHandle.text = "@" + user.screenname!
        tweetsCount.text = user.tweetsCount?.description
        followingCount.text = user.followingCount?.description
        followersCount.text = user.followersCount?.description
    }

}
