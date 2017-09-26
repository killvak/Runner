//
//  OrdersCell.swift
//  RunnerApp
//
//  Created by admin on 9/26/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class OrdersCell: UITableViewCell {

    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var dateofOrder: UILabel!
    @IBOutlet weak var orderSerialNum: UILabel!
    @IBOutlet weak var orderDetails: UILabel!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var viewMoreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
