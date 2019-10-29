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
    @IBOutlet weak var daysLabelCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    var monthIndex:Int!
    var year:Int!
    var month:Int!
    var fromSegue:Bool = false
    var segueMonthIndex:Int!
    var segueYear:Int!
    var segueMonth:Int!
    
    //MARK: - Main Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.monthIndex = Methods.getMonthComponent(date: Globals.dateTracker!) - 1 //Month starts at 1
        self.monthNavBar.title = Constants.MONTHS[self.monthIndex]
        year = Methods.getYearComponent(date: Globals.dateTracker!)
        month = Methods.getMonthComponent(date: Globals.dateTracker!)
        self.daysLabelCollectionView.delegate = self
        self.daysLabelCollectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.daysLabelCollectionView.backgroundColor = UIColor.gray
        
        //Configure collection view
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: UIScreen.main.bounds.width/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.collectionViewLayout = layout
        
        let layout2:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
 //       layout2.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout2.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: UIScreen.main.bounds.width/7)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        self.daysLabelCollectionView.collectionViewLayout = layout2
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if (self.fromSegue)
        {
            self.monthIndex = self.segueMonthIndex
            self.monthNavBar.title = Constants.MONTHS[self.monthIndex]
            year = self.segueYear
            month = self.segueMonth
        }
   //     print("monthly calendar view will appear")
        self.collectionView.reloadData()
    }
    
    //MARK: - Protocols
    //tell the collection view how many cells to make
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
    {
        if (collectionView == self.collectionView)
        {
            return Globals.fullListOfCalendarDays[self.monthIndex].count
        }
        else
        {
            return Constants.DAYS.count
        }
    }
    
    //Make a cell for each cell index path
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //get a reference to our storyboard cell
        if (collectionView == self.collectionView)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CVC_CALENDAR_MONTHLY_CELL, for: indexPath as IndexPath) as! MonthlyCalendarCVC
            
            //Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.label.text = Globals.fullListOfCalendarDays[self.monthIndex][indexPath.row]
            cell.month = self.month
            cell.year = self.year
            let day:String = cell.label.text!
            if (day != "")
            {
                cell.day = Int(day)
            }
            else
            {
                cell.day = 0
            }
            cell.tableView.delegate = cell.self
            cell.tableView.dataSource = cell.self
            cell.tableView.reloadData()
            
            //Customize cell
            cell.layer.borderWidth = 1
            
            return cell
        }
        else        //days label collectionview
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CVC_CALENDAR_MONTHLY_DAY_LABEL_CELL, for: indexPath as IndexPath) as! MonthlyCalendarDaysCVC
            
            cell.label.text = Constants.DAYS[indexPath.row]
            
            cell.label.textAlignment = NSTextAlignment.center
       //     cell.label.backgroundColor = UIColor.gray
            
 //           cell.layer.borderWidth = 1
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //handle tap events
//        print("You selected cell #\(indexPath.item)!")
        print("I should go here first")
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
        guard let _ = Globals.wishlistDictionary[self.year]?[self.month]?[Int(Globals.fullListOfCalendarDays[self.monthIndex][collectionView.indexPathsForSelectedItems?.first?.item ?? 0])!] else
        {
            return
        }
        self.performSegue(withIdentifier: Constants.SEGUE_CALEDAR_MONTH_TO_WISHLIST_DETAIL, sender: collectionView.cellForItem(at: indexPath))
    }
    
    //MARK: - Overriden Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) //This function is called when we want to navigate to a new screen using segue
    {
        if let cell = sender as? UICollectionViewCell
        {
            if (segue.identifier == Constants.SEGUE_CALEDAR_MONTH_TO_WISHLIST_DETAIL)
            {
                let detailViewController = segue.destination as! MonthlyCalendarWishlistDetailVC
                let indexPath = self.collectionView.indexPath(for: cell)
                let day:String = Globals.fullListOfCalendarDays[self.monthIndex][indexPath!.item]
                //          print("day: \(day)")
                //          print("selectedIndex: \(self.selectedIndex)")
                if (day != "")
                {
                    detailViewController.wishlists = Globals.wishlistDictionary[self.year]?[self.month]?[Int(day)!] ?? []
                }
                else
                {
                    detailViewController.wishlists = []
                }
            }
        }
        
    }
}
