//
//  FilterCell.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/25/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var filterCellLabel: UILabel!
    @IBOutlet weak var checkerImageView: UIImageView!
    var checkerCondition: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showChecker(_ show: Bool) {
        checkerImageView.isHidden = !show
    }
}
