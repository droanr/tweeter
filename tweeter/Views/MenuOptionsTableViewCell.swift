//
//  MenuOptionsTableViewCell.swift
//  tweeter
//
//  Created by drishi on 10/7/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class MenuOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var optionsLabel: UILabel!
    var optionName: String! {
        didSet {
            optionsLabel.text = optionName
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
