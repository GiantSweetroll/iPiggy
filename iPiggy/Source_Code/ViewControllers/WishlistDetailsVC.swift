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
    
    //MARK: - Variables
    var wishlistItem:WishlistItem!
    
    //MARK: - Main Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.wishName.text = self.wishlistItem.name
        self.date.text = Globals.dateFormatFull.string(from: self.wishlistItem.date!)
        self.amount.text = Methods.appendCurrency(string: String(self.wishlistItem.cost))
    }
}
