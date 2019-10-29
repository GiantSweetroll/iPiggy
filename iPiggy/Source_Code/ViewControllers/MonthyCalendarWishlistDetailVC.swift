//
//  MonthyCalendarWishlistDetailVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 27/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class MonthlyCalendarWishlistDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: - IBOutlets
    
    //MARK: - Variables
    var wishlists:[WishlistItem]!
    
    //MARK: - Main Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.wishlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TVC_WISHLIST_MONTH_CALENDAR, for: indexPath) as! MonthlyCalendarWishlistDetailTVC
        
        let wishlist:WishlistItem = self.wishlists[indexPath.row]
        
        cell.wishlistName.text = wishlist.name!
        cell.cost.text = Methods.appendCurrency(string: String(format: "%0.0f", wishlist.cost))
        cell.date.text = Globals.dateFormatFull.string(from: wishlist.date!)
        let achieved:Bool = wishlist.achieved
        if (achieved)
        {
            cell.achieved.text = "Achieved!"
            cell.achievedImageView.image = UIImage(systemName: "checkmark.circle")
        }
        else
        {
            cell.achieved.text = "Not Achieved"
            cell.achievedImageView.image = UIImage(systemName: "circle")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
}
