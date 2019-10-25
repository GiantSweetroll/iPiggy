//
//  MonthlyCalendarVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 24/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class MonthlyCalendarVC:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    //MARK: - IBOutlets
    @IBOutlet weak var monthNavBar: UINavigationItem!
    
    //MARK: - Variables
    var monthIndex:Int!
    
    //MARK: - Main Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.monthIndex = 9
        self.monthNavBar.title = Constants.MONTHS[self.monthIndex]
    }
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CVC_CALENDAR_MONTHLY_CELL, for: indexPath as IndexPath) as! MonthlyCalendarCVC
        
        //Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.label.text = Globals.fullListOfCalendarDays[self.monthIndex][indexPath.row]
        
        //Customize cell
        if (indexPath.row < Constants.DAYS.count)
        {
            cell.label.backgroundColor = UIColor.gray
            cell.label.textAlignment = NSTextAlignment.center
        }
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    //MARK: - Trial Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat        //Spacing between rows
    {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat   //Spacing between columns
    {
        return 0
    }
}
