//
//  GamesTableViewCell.swift
//  IosFundamentalSubmission
//
//  Created by User on 12/09/26.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
