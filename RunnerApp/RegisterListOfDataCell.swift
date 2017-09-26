//
//  RegisterListOfDataCell.swift
//  RunnerApp
//
//  Created by admin on 9/25/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class RegisterListOfDataCell: UITableViewCell {

    var selectedBtnTag : Int?
    @IBOutlet weak var dataTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
