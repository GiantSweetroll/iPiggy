//
//  AchievementTableCell.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class AchievementTableCell: UITableViewCell
{
    //MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    
    //MARK: - Primary Methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

