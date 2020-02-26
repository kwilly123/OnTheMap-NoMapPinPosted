//
//  DataViewCell.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-17.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit

class DataViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var url: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
