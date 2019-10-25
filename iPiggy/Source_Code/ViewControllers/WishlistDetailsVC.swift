//
//  WishlistDetailsVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 24/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class WishlistDetailsVC: UIViewController
{
    //MARK: - IBOutlets
    @IBOutlet weak var wishName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var achieved: UILabel!
    @IBOutlet weak var achievedImage: UIImageView!
    
    //MARK: - Variables
    var wishlistItem:WishlistItem!
    
    //MARK: - Main Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.wishName.text = self.wishlistItem.name
        self.date.text = Globals.dateFormatFull.string(from: self.wishlistItem.date!)
        self.amount.text = Methods.appendCurrency(string: String(format: "%0.0f", self.wishlistItem.cost))
        let achieved:Bool = self.wishlistItem.achieved
        if (achieved)
        {
            self.achieved.text = "Achieved!"
            self.achievedImage.image = UIImage(systemName: "checkmark.circle")
        }
        else
        {
            self.achieved.text = "Not Achieved"
            self.achievedImage.image = UIImage(systemName: "circle")
        }
    }
    
    //MARK: - Other Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) //This function is called when we want to navigate to a new screen using segue
    {
        if (segue.identifier == Constants.SEGUE_WISHLIST_DETAILS_TO_FORM)
        {
            let wishlistFormVC = segue.destination as! AchievementFormVC
            wishlistFormVC.newEntry = false
            wishlistFormVC.wishlistItem = self.wishlistItem
        }
    }
    
    //MARK: - Actions
    @IBAction func editButtonPressed(_ sender: Any)
    {        
        self.performSegue(withIdentifier: Constants.SEGUE_WISHLIST_DETAILS_TO_FORM, sender: nil)
    }
    @IBAction func deleteButtonPressed(_ sender: Any)
    {
        Methods.deleteWishlist(wishlist: self.wishlistItem)
        navigationController?.popViewController(animated: true)
    }
}
