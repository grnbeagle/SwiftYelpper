//
//  FilterCell.swift
//  SwiftYelpper
//
//  Created by Amie Kweon on 4/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
