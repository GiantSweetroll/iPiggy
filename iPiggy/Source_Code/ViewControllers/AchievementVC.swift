//
//  AchievementVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import UIKit

class AchievementVC:UIViewController, UITableViewDataSource, UITableViewDelegate, WishlistTableCellDelegate
{
    //MARK: - IBOutlets
    @IBOutlet weak var wishlistTabelView: UITableView!
    @IBOutlet weak var achievementTableView: UITableView!
    
    //MARK: - Variables
//    var achievements:[Achievement]!
    var selectedRow:Int!
    var achievements:[Achievement] = [Achievement]()
    
    //MARK: - Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialize
        self.wishlistTabelView.dataSource = self
        self.wishlistTabelView.delegate = self
        self.achievementTableView.dataSource = self
        self.achievementTableView.delegate = self
 //       self.achievements = []
        
        self.achievementTableView.backgroundColor = UIColor.gray
    }
    override func viewWillAppear(_ animated: Bool)
    {
 //       print(#function)
        super.viewWillAppear(animated)
        
        self.achievements = Methods.getAchievedAchievements()
        Methods.loadWishlists()
 //       print("count is \(Globals.wishlists.count)")
 //       print("Size of wishlist: \(Globals.wishlists.count)")
        self.wishlistTabelView.reloadData()
        self.achievementTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) //This function is called when we want to navigate to a new screen using segue
    {
        if (segue.identifier == Constants.SEGUE_WISHLIST_DETAILS)
        {
            let detailsVC = segue.destination as! WishlistDetailsVC
            let wishlistItem = Globals.wishlists[self.selectedRow]
            detailsVC.wishlistItemIndex = self.selectedRow
            detailsVC.wishlistItem = wishlistItem
//            detailsVC.wishlistIndex = self.selectedRow
        }
    }
    
    //MARK: - Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == self.wishlistTabelView)
        {
            return Globals.wishlists.count
        }
        else
        {
            return self.achievements.count
   //         return Globals.achievements.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == self.wishlistTabelView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TVC_WISHLIST, for: indexPath) as! WishlistTableCell
            
            let wishlist = Globals.wishlists[indexPath.row]
            
            cell.label.text = wishlist.name
            cell.setAchieved(achieved: wishlist.achieved)
            cell.delegate = self
            
            return cell
        }
        else        //Achievement table
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TVC_ACHIEVEMENT, for: indexPath) as! AchievementTableCell
            
     //       let achievement = self.achievements[indexPath.row]
            let achievement = self.achievements[indexPath.row]
            
            cell.label.text = achievement.details
            cell.backgroundColor = UIColor.gray
            
            return cell
        }
    }
    func onAchievedButtonPressed(_ cell: WishlistTableCell)
    {
        guard let indexPath = wishlistTabelView.indexPath(for: cell) else
        {
            return
        }
            
 //       print(indexPath.row)
            
        // update database and the master array
        let wishlist:WishlistItem = Globals.wishlists[indexPath.row]
        wishlist.achieved = !wishlist.achieved
        Methods.updateWishlistAchieved(wishlist: wishlist, achieved: wishlist.achieved)
            
        // update tableview
        wishlistTabelView.reloadRows(at: [indexPath], with: .automatic)
    }
    func onDetailsButtonPressed(_ cell: WishlistTableCell)
    {
        guard let indexPath = wishlistTabelView.indexPath(for: cell) else
        {
            return
        }
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: Constants.SEGUE_WISHLIST_DETAILS, sender: nil)
    }
}
