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
    var delegate: WishlistTableCellDelegate?
    
    //MARK: - Variables
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
//        self.achieved = false
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Button Methods
    @IBAction func buttonPressed(_ sender: Any)
    {
//        self.setAchieved(achieved: !(self.achieved!))
        delegate?.onAchievedButtonPressed(self)
    }
    @IBAction func buttonDetailsPressed(_ sender: Any)
    {
        self.delegate?.onDetailsButtonPressed(self)
    }
    
    //MARK: - Other Methods
    public func setAchieved(achieved:Bool)
    {
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
 //       self.butAchieved.imageView?.image = UIImage(contentsOfFile: "circle.fill")
        self.butAchieved.setImage(UIImage(systemName: "checkmark"), for: .normal)
    }
    public func removeImageFromButton()
    {
 //       self.butAchieved.imageView?.image = nil
        self.butAchieved.setImage(nil, for: .normal)
    }
}

protocol WishlistTableCellDelegate
{
    func onAchievedButtonPressed(_ cell: WishlistTableCell)
    func onDetailsButtonPressed(_ cell: WishlistTableCell)
}
