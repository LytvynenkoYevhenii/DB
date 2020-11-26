//
//  CoctailCell.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/24/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit

class CoctailCell: UITableViewCell {
    @IBOutlet weak var coctailImage: UIImageView!
    
    @IBOutlet weak var coctailNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
