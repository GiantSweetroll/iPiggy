//
//  YearlyCalendarVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 24/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class YearlyCalendarVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate
{
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    //Variables
    private var selectedIndex:Int?
    
    //MARK: - Main Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  //      layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
  //      print(UIScreen.main.bounds.width/2)
        layout.itemSize = CGSize(width: 170, height: 165)       //Trail and error
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.monthCollectionView.collectionViewLayout = layout
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.monthCollectionView.reloadData()
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == Constants.SEGUE_CALENDAR_YEAR_TO_MONTH)
        {
            let monthCalendarVC = segue.destination as! MonthlyCalendarVC
            monthCalendarVC.fromSegue = true
            monthCalendarVC.segueMonthIndex = self.selectedIndex ?? 1
            monthCalendarVC.segueYear = Globals.currentYearlyCalendarYearDisplayed
            monthCalendarVC.segueMonth = monthCalendarVC.segueMonthIndex+1
        }
    }
    
    //MARK: - Protocols
    //tell the collection view how many cells to make
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
    {
//       return Globals.fullListOfCalendarDays.count
        return Constants.MONTHS_SHORT.count
    }
    
    //Make a cell for each cell index path
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //get a reference to our storyboard cell
        let cell = self.monthCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CVC_CALENDAR_YEARLY_MONTHLY_CELL, for: indexPath as IndexPath) as! YearMonthCalendarCVC
        
        //Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.monthLabel.text = Constants.MONTHS_SHORT[indexPath.item]
        cell.monthIndex = indexPath.row
        cell.year = Globals.currentYearlyCalendarYearDisplayed
        cell.month = cell.monthIndex+1
        
 //       cell.layer.borderWidth = 1
 //       cell.layer.borderColor = UIColor.red.cgColor
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //Handles cell tap events
        self.selectedIndex = indexPath.item
  //      print(self.selectedIndex!)
        performSegue(withIdentifier: Constants.SEGUE_CALENDAR_YEAR_TO_MONTH, sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat        //Spacing between rows
    {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat   //Spacing between columns
    {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int //Tells the TableView how many rows of data in a section
    {
        //TODO create yearly achievement array
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  //Prepares a cell and fills it with some data
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TVC_YEARLY_ACHIEVEMENT, for: indexPath) as! YearlyAchievementTableCell
        
        cell.achievement.text = "Replace me please"
        
        return cell
    }
}
