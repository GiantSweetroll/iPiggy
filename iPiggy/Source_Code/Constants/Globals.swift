//
//  Globals.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Charts

struct Globals
{
    
    public static var histories:[Expenses]=[]
    public static var wishlists:[WishlistItem]=[]
    public static var wishlistDictionary:Dictionary<Int, Dictionary<Int, Dictionary<Int, [WishlistItem]>>> = Dictionary<Int, Dictionary<Int, Dictionary<Int, [WishlistItem]>>>()
    public static var monthCollectionViews:[UICollectionView] = []
    public static var fullListOfCalendarDays:[[String]] = [[]]
    public static var labFunds:UILabel?
    public static var labRecSpending:UILabel?
    public static var labGoals:UILabel?
    public static var labGoalDayLeft:UILabel?
    public static var labExpensesToday:UILabel?
    public static var pieChart:PieChartView?
    public static var goalsComplete:PieChartDataEntry = PieChartDataEntry(value: 0)
    public static var goalsIncomplete:PieChartDataEntry = PieChartDataEntry(value: 100)
    public static var goalsProgress = [PieChartDataEntry]()
    public static var fundsDataObject:NSManagedObject?
    public static var goalsDataObject:NSManagedObject?
    public static var goals:Goal?
    public static var achievements:[Achievement] = [Achievement]()
    public static var funds:Double = 0
    public static var fundsSpent:Double = 0
    public static var recSpending:Double = 0
    public static var currentYearlyCalendarYearDisplayed:Int?
    public static var dateTracker:Date?
    public static var isNewAchievement:Bool = false
    public static var dateFormatFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    public static var dateFormatMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
