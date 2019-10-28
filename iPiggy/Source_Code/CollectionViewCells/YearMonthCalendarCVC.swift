//
//  YearMonthCalendarCVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 24/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class YearMonthCalendarCVC:UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    //MARK: - IBOutlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    //MARK: - Variables
    var monthIndex:Int! {
        didSet {
            collectionView.reloadData()
        }
    }
    var year:Int!
    var month:Int!
    
    //MARK: - Protocols
    //tell the collection view how many cells to make
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
    {
        return Globals.fullListOfCalendarDays[self.monthIndex].count
    }
    
    //Make a cell for each cell index path
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    //    print(#function)
        //get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CVC_CALENDAR_YEARLY_DAILY_CELL, for: indexPath as IndexPath) as! YearDayCalendarCVC
        
        //Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.dayLabel.text = Globals.fullListOfCalendarDays[self.monthIndex][indexPath.item]
        if (cell.dayLabel.text != "")
        {
            let wishlist:WishlistItem? = Globals.wishlistDictionary[year]?[month]?[Int(cell.dayLabel.text!)!]?[0]
            if (wishlist != nil)
            {
                cell.dayLabel.textColor = UIColor.blue
            }
        }
        
 //       cell.layer.borderWidth = 1
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat        //Spacing between rows
    {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat   //Spacing between columns
    {
        return 0
    }
    
    //MARK: - Other Methods
    fileprivate func setupCollectionView()
    {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //            layout.itemSize = CGSize(width: UIScreen.main.bounds.width/14, height: UIScreen.main.bounds.width/14)
        layout.itemSize = CGSize(width: 22, height: 22)         //Trial and Error
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
}
