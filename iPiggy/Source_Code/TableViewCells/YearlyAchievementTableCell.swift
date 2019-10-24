//
//  YearlyAchievementTableCell.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 25/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class YearlyAchievementTableCell:UITableViewCell
{
    //MARK: IBOutlets
    @IBOutlet weak var achievement: UILabel!
    
    
    //MARK: - Main Methods
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
