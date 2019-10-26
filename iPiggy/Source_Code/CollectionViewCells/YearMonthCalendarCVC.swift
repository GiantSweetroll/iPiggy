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
    
    //MARK: - Variables
    var monthIndex:Int!
    
    //MARK: - Protocols
    //tell the collection view how many cells to make
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
    {
        return Globals.fullListOfCalendarDays[self.monthIndex].count
    }
    
    //Make a cell for each cell index path
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CVC_CALENDAR_YEARLY_DAILY_CELL, for: indexPath as IndexPath) as! YearDayCalendarCVC
        
        //Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.dayLabel.text = Globals.fullListOfCalendarDays[self.monthIndex][indexPath.item]
        
        cell.layer.borderWidth = 1
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat        //Spacing between rows
    {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat   //Spacing between columns
    {
        return 0
    }
}
