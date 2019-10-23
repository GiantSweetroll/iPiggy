//
//  HistoryTableViewCell.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class HistoryTableViewCell:UITableViewCell
{
    //MARK: - Cell Elements
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var info: UILabel!
    {
        didSet
        {
            info.sizeToFit()
        }
    }
    
    
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
