//
//  WishlistTableCell.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class WishlistTableCell: UITableViewCell
{
    //MARK: - Storyboard Elements
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var butAchieved: UIButton!
    @IBOutlet weak var butDetails: UIButton!
    
    //MARK: - Variables
    private var achieved:Bool?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.achieved = false
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Button Methods
    @IBAction func buttonPressed(_ sender: Any)
    {
        self.setAchieved(achieved: !(self.achieved!))
    }
    
    //MARK: - Other Methods
    public func setAchieved(achieved:Bool)
    {
        self.achieved = achieved
        if (achieved)
        {
            setImageToButton()
        }
        else
        {
            removeImageFromButton()
        }
    }
    public func setImageToButton()
    {
        self.butAchieved.imageView?.image = UIImage(contentsOfFile: "circle.fill")
    }
    public func removeImageFromButton()
    {
        self.butAchieved.imageView?.image = nil
    }
}
