//
//  Methods.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Charts

struct Methods
{
    public static func appendCurrency(string:String) -> String
    {
        return "\(Constants.CURRENCY) \(string)"
    }
    
    //MARK: - Funds Handling
    public static func loadFunds()       //Load funds from database
    {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITY_FUNDS)
        
        //3
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            if (array.count > 0)
            {
                Globals.fundsDataObject = array.last
            }
            else        //No data in database yet
            {
                let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
                       
                Globals.fundsDataObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                Methods.saveFunds(funds: 0)
                Methods.saveMoneySpent(value: 0)
            }
            Globals.funds = Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_TOTAL) as! Double
            Globals.fundsSpent = Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_EXPENSE) as! Double
            Globals.dateTracker = Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_DATE_TRACKER) as? Date
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    public static func saveFunds(funds:Double)     //Save funds to database
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
//       let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
        
//       let funds = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        Globals.fundsDataObject?.setValue(funds, forKey: Constants.CD_FUNDS_TOTAL)
        
        //4
        do
        {
            try managedContext.save()
            Globals.funds = funds
            Methods.updateHomepageFundsLabel(funds: funds)
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func updateHomepageFundsLabel(funds:Double)
    {
        Globals.labFunds?.text = Methods.appendCurrency(string: String(format: "%0.0f", funds))
    }
    
    //MARK: - Goals Handling
    public static func saveGoals(dateFrom: Date, dateTo:Date, amount:Double)       //Save to database
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        //3
        Globals.goalsDataObject?.setValue(dateFrom, forKey: Constants.CD_GOALS_DATE_FROM)
        Globals.goalsDataObject?.setValue(dateTo, forKey: Constants.CD_GOALS_DATE_TO)
        Globals.goalsDataObject?.setValue(amount, forKey: Constants.CD_GOALS_AMOUNT)
        
        //4
        do
        {
            try managedContext.save()
            //MARK: - Update chart and goals label in Homepage
            Globals.goals?.amount = amount
            Methods.updateHomepageGoalsLabel(goals: amount)
            Methods.updateHomepageGoalsDayLeftLabel()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func loadGoals()
    {
//1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITIY_GOALS)
        
        //3
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            if (array.count > 0)
            {
                Globals.goalsDataObject = array.last
            }
            else
            {
                let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITIY_GOALS, in: managedContext)
                        
                Globals.goalsDataObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                Methods.saveGoals(dateFrom: Date(), dateTo: Date(), amount: 0)
            }
            Globals.goals = Globals.goalsDataObject as? Goal
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    public static func updateHomepageGoalsLabel(goals:Double)
    {
        Globals.labGoals?.text = Methods.appendCurrency(string: String(format: "%0.0f", goals))
    }
    public static func updateHomepageGoalsDayLeftLabel()
    {
        let dateComponent:DateComponents = Methods.getDayDifference(from: Globals.goals!.dateFrom!, to: Globals.goals!.dateTo!)
        Globals.labGoalDayLeft?.text = String(dateComponent.day!)
    }
    
    //MARK: - Manage Expenses and Histories
    public static func saveExpenses(category: String, description:String, amount: Double, date:Date)
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_EXPENSES, in: managedContext)
        
        let expenses = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        expenses.setValue(category, forKey: Constants.CD_EXPENSES_CATEGORY)
        expenses.setValue(description, forKey: Constants.CD_EXPENSES_DESCRIPTION)
        expenses.setValue(amount, forKey: Constants.CD_EXPENSES_AMOUNT)
        expenses.setValue(date, forKey: Constants.CD_EXPENSES_DATE)
        
        //4
        do
        {
            try managedContext.save()
//           expenses.append(person)
            Globals.histories.append(expenses as! Expenses)     //Add to array for table view data source
  //          print("dateTracker: \(Globals.dateFormatFull.string(from: Globals.dateTracker!))")
  //          print("Date: \(Globals.dateFormatFull.string(from: date))")
  //          print("Are they same? \(date == Globals.dateTracker)")
  //          if (date == Globals.dateTracker)
            if (Methods.isSameDate(date1: date, date2: Globals.dateTracker ?? Date()))
            {
                Methods.saveMoneySpent(value: Globals.fundsSpent + amount)
            }
            else
            {
                Methods.saveFunds(funds: Globals.funds - amount)
            }
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func loadExpenses()
    {
        var expensesData: [Expenses] = []

        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITY_EXPENSES)
        
        //3
        do
        {
            expensesData = try managedContext.fetch(fetchRequest) as! [Expenses]
   //         print("Array expeneses data size: \(expensesData.count)")
            if (expensesData.count > 0)
            {
                Globals.histories = expensesData
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    public static func saveMoneySpent(value:Double)     //Save money spent to database
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
//       let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
        
//       let funds = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        Globals.fundsDataObject?.setValue(value, forKey: Constants.CD_FUNDS_EXPENSE)
        
        //4
        do
        {
            try managedContext.save()
            Globals.fundsSpent = value
            Methods.saveFunds(funds: Globals.funds - value)
            Methods.updateHomepageFundsSpentLabel(fundsSpent: Globals.fundsSpent)
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func updateHomepageFundsSpentLabel(fundsSpent:Double)
    {
        Globals.labExpensesToday?.text =  String(format: "%0.0f", fundsSpent)
    }
    public static func updateDateTracker()     //Save money spent to database
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
//       let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
        
//       let funds = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        Globals.fundsDataObject?.setValue(Date(), forKey: Constants.CD_FUNDS_DATE_TRACKER)
        
        //4
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Wishlist Management
    public static func saveWishlist(name:String, cost:Double, date:Date, achieved:Bool)     //New Entry
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_WISHLIST, in: managedContext)
        
        let wishlist = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        wishlist.setValue(name, forKey: Constants.CD_WISHLIST_NAME)
        wishlist.setValue(cost, forKey: Constants.CD_WISHLIST_COST)
        wishlist.setValue(date, forKey: Constants.CD_WISHLIST_DATE)
        wishlist.setValue(achieved, forKey: Constants.CD_WISHLIST_ACHIEVED)
        
        //4
        do
        {
            try managedContext.save()
//           expenses.append(person)
            //MARK: - Add to history here
            Globals.wishlists.append(wishlist as! WishlistItem)
            
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func loadWishlists()
     {
         var wishlistData: [WishlistItem] = []

         //1
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
         {
             return
         }
         
         let managedContext = appDelegate.persistentContainer.viewContext
         
         //2
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITY_WISHLIST)
         
         //3
         do
         {
             wishlistData = try managedContext.fetch(fetchRequest) as! [WishlistItem]
    //         print("Array expeneses data size: \(expensesData.count)")
             if (wishlistData.count > 0)
             {
                Globals.wishlists = wishlistData
             }
         }
         catch let error as NSError
         {
             print("Could not fetch. \(error), \(error.userInfo)")
         }
     }
    public static func updateWishlistAchieved(wishlist:WishlistItem, achieved:Bool)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        
        wishlist.setValue(achieved, forKey: Constants.CD_WISHLIST_ACHIEVED)
        
        //Save to database
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func saveWishlist(wishlist: WishlistItem, name:String, cost:Double, date:Date, achieved:Bool)     //Existing Entry
    {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        
        wishlist.setValue(achieved, forKey: Constants.CD_WISHLIST_ACHIEVED)
        wishlist.setValue(name, forKey: Constants.CD_WISHLIST_NAME)
        wishlist.setValue(cost, forKey: Constants.CD_WISHLIST_COST)
        wishlist.setValue(date, forKey: Constants.CD_WISHLIST_DATE)
        
        //Save to database
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func deleteWishlist(wishlist: WishlistItem)     //Delete wishlist
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Save to database
        do
        {
            try managedContext.delete(wishlist)
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Calendar Operations
    public static func isLeapYear(year:Int) -> Bool
    {
        return year%4==0
    }
    public static func getYearComponent(date: Date) -> Int
    {
        return Calendar.current.component(.year, from: date)
    }
    public static func getMonthComponent(date: Date) -> Int
    {
        return Calendar.current.component(.month, from: date)
    }
    public static func getDayComponent(date:Date) -> Int
    {
        return Calendar.current.component(.day, from: date)
    }
    public static func getWeekdayUnit(date: Date) -> Int
    {
        return Calendar.current.component(.weekday, from: date)
    }
    public static func isSameDate(date1: Date, date2: Date) -> Bool
    {
        let date1Day:Int = Methods.getDayComponent(date: date1)
        let date1Month:Int = Methods.getMonthComponent(date: date1)
        let date1Year:Int = Methods.getYearComponent(date: date1)
        
        let date2Day:Int = Methods.getDayComponent(date: date2)
        let date2Month:Int = Methods.getMonthComponent(date: date2)
        let date2Year:Int = Methods.getYearComponent(date: date2)
        
        return date1Day == date2Day && date1Month == date2Month && date1Year == date2Year
    }
    public static func getAmountOfDaysArray(isLeapYear: Bool) -> [Int]
    {
        var array:[Int] = []
        
        //First pass (jan to july)
        for i in 1...7
        {
            if (i == 2)     //If ferbuary
            {
                if isLeapYear
                {
                    array.append(29)
                }
                else
                {
                    array.append(28)
                }
            }
            else if (i%2==0)     //If 30 days
            {
                array.append(30)
            }
            else        //31 days
            {
                array.append(31)
            }
        }
        //Second Pass (August to December)
        for i in 1...5
        {
            if (i%2==0)     //If 30 days
            {
                array.append(30)
            }
            else            //31 Days
            {
                array.append(31)
            }
        }
        
        return array
    }
    public static func getDayDifference(from dateFrom:Date, to dateTo:Date) -> DateComponents
    {
        return Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo)
    }
    public static func generateYearlyCalendarArray(year: Int) -> [[String]]
    {
        var array:[[String]] = [[]]
        let daysArray:[Int] = Methods.getAmountOfDaysArray(isLeapYear: Methods.isLeapYear(year: year))
        
        var remainder:Int = Methods.getWeekdayStartOfYear(year: year) - 1
        var gapEarlyOfMonth:Int = remainder
        var gapEndOfMonth:Int = 0
        
        for i in 0...11     //12 Months
        {
            var subArr:[String] = []
            var counter:Int = 0
            
            //Fill in gaps early of the month
            for _ in 0..<gapEarlyOfMonth
            {
                subArr.append("")
                counter+=1
            }
            
            //Fill in days
            for a in 1...daysArray[i]
            {
                subArr.append(String(a))
                counter+=1
            }
            
            //Calculating gap at the end of the week
            remainder = counter%7
 //           print(remainder)
            if (remainder==0)
            {
                gapEndOfMonth = 0
            }
            else
            {
                gapEndOfMonth = 7-remainder
            }
            //Fill in gap at the end of the month
            for _ in 0..<gapEndOfMonth
            {
                subArr.append("")
            }
            
            //Add subArray to main array
            array.append(subArr)
            
            //Calculate gap early of the next month
            gapEarlyOfMonth = remainder
        }
        
        array.remove(at: 0) //Remove first empty array
        
        return array
    }
    public static func getWeekdayStartOfYear(year: Int) -> Int
    {
        //Get first date of X year
        let firstDateOfXYear = Calendar.current.date(from: DateComponents(year: year, month:1, day: 1))
        
        return Methods.getWeekdayUnit(date: firstDateOfXYear!)
    }
    public static func addDayLabelsToCalendarArray()
    {
        for i in 0..<Globals.fullListOfCalendarDays.count
        {
            Globals.fullListOfCalendarDays[i].insert(contentsOf: Constants.DAYS, at: 0)
        }
    }
    public static func setDateTimeToOrigin(date: Date) -> Date
    {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    }
    
    //MARK: - Manage Recommended Spending
    public static func getRecommendedSpending(allocatedFunds funds: Double, goal:Double, timeDurationInDays duration:Int) -> Double
    {
        if (duration <= 0)
        {
            return 0
        }
        else
        {
            let maxAllocatedFunds:Double = funds/Double(duration)
            let eachDaySave:Double = goal/Double(duration)
            
            return maxAllocatedFunds - eachDaySave
        }
    }
    public static func getRecommendedSpending() -> Double
    {
        return Methods.getRecommendedSpending(allocatedFunds: Globals.funds, goal: Globals.goals?.amount ?? 0, timeDurationInDays: Methods.getDayDifference(from: Globals.goals?.dateFrom ?? Date(), to: Globals.goals?.dateTo ?? Date()).day ?? 0)
    }
    public static func getRecommendedSpendingNoDecimal() -> Int
    {
        return Int(Methods.getRecommendedSpending())
    }
    public static func saveRecommendedSpending(recommendedSpending amount:Double)     //Save recommended spending to database
    {
        //MARK: - Saving to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
//       let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
        
//       let funds = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        Globals.fundsDataObject?.setValue(amount, forKey: Constants.CD_FUNDS_REC_SPENDING)
        
        //4
        do
        {
            try managedContext.save()
            Methods.updateHomepageRecommendedSpendingLabel(amount: amount)
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func updateHomepageRecommendedSpendingLabel(amount: Double)
    {
        Globals.labRecSpending?.text = String(format: "%0.0f", amount)
    }
    
    //MARK: - Manage Charts
    public static func updateChartData()
    {
        let chartDataSet = PieChartDataSet(entries: Globals.goalsProgress, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.gray]
        chartDataSet.colors = colors as! [NSUIColor]
        
        Globals.pieChart!.data = chartData
    }
}
