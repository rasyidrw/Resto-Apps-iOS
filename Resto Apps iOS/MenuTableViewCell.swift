//
//  MenuTableViewCell.swift
//  Resto Apps iOS
//
//  Created by Rasyid Respati Wiriaatmaja on 03/02/20.
//  Copyright © 2020 rasyidrw. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgGambar: UIImageView!
    @IBOutlet weak var lblNama: UILabel!
    @IBOutlet weak var lblHarga: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
