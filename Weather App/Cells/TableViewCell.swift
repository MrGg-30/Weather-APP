//
//  TableViewCell.swift
//  Weather App
//
//  Created by Tornike on 12.02.22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabeL: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var imageV: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
