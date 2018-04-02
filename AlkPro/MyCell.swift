//
//  MyCell.swift
//  AlkPro
//
//  Created by Sierra on 3/30/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var Datelbl: UILabel!
    @IBOutlet weak var Dayslbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
