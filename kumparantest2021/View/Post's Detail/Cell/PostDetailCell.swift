//
//  PostDetailCell.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

class PostDetailCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
