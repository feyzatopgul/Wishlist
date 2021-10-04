//
//  TableTableViewCell.swift
//  Wishlist
//
//  Created by fyz on 6/26/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var itemPhoto: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
