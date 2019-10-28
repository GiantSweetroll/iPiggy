//
//  MonthlyCalendarCVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 24/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class MonthlyCalendarCVC:UICollectionViewCell, UITableViewDataSource, UITableViewDelegate
{
    //MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var year:Int!
    var month:Int!
    var day:Int!
    
    //MARK: - Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Globals.wishlistDictionary[year]?[month]?[day]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TVC_MONTH_WISHLIST, for: indexPath) as! MonthAchievementTableViewCell
        
        let wishlist:WishlistItem? = Globals.wishlistDictionary[year]?[month]?[day]?[indexPath.row]
        
        cell.label.text = wishlist?.name ?? ""
        
        return cell
    }
}
