//
//  AchievementVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import UIKit

class AchievementVC:UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: - IBOutlets
    @IBOutlet weak var wishlistTabelView: UITableView!
    @IBOutlet weak var achievementTableView: UITableView!
    
    //MARK: - Variables
    var wishlists:[Wishlist]!
    var achievements:[Achievement]!
    
    //MARK: - Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialize
        self.wishlistTabelView.dataSource = self
        self.wishlistTabelView.delegate = self
        self.achievementTableView.dataSource = self
        self.achievementTableView.delegate = self
        self.wishlists = []
        self.achievements = []
    }
    
    //MARK: - Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == self.wishlistTabelView)
        {
            return self.wishlists.count
        }
        else
        {
            return self.achievements.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == self.wishlistTabelView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CD_ENTITY_WISHLIST, for: indexPath) as! WishlistTableCell
            
            let wishlist = self.wishlists[indexPath.row]
            
            cell.label.text = wishlist.name
            cell.setAchieved(achieved: wishlist.achieved!)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CD_ENTITY_WISHLIST, for: indexPath) as! AchievementTableCell
            
            let achievement = self.achievements[indexPath.row]
            
            cell.label.text = achievement.achievement
            
            return cell
        }
    }
}
