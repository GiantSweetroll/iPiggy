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
    public static func saveSurplus(surplus amount:Double)     //Save surplus to database
    {
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
        Globals.fundsDataObject?.setValue(amount, forKey: Constants.CD_FUNDS_SURPLUS)
        
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
    public static func checkSurplus()
    {
        guard let _ = Globals.goals?.value(forKey: Constants.CD_FUNDS_SURPLUS) else
        {
            Methods.saveSurplus(surplus: 0)
            return
        }
    }
    public static func getSurplus() -> Double
    {
        return Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_SURPLUS) as? Double ?? 0
    }
    public static func calculateSurplus(recommendedSpending recSpend: Double, moneySpent: Double) -> Double
    {
        return recSpend - moneySpent
    }
    public static func getMoneySavedYesterday() -> Double
    {
        let yesterdaySurplus:Double = Methods.calculateSurplus(recommendedSpending: Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_REC_SPENDING) as! Double, moneySpent: Globals.fundsSpent)
        let dailyGoalSavings:Double = (Globals.goals?.amount)!/Double(Methods.getDayDifference(from: Globals.goals?.dateFrom ?? Date(), to: Globals.goals?.dateTo ?? Date()).day ?? 0)
        
        let amount:Double = dailyGoalSavings + yesterdaySurplus
        if (amount<0)
        {
            return 0
        }
        else
        {
            return amount
        }
    }
    
    //MARK: - Goals Handling
    public static func saveGoals(dateFrom: Date, dateTo:Date, moneyToSave amount:Double, moneyAllocated fundsAlloc: Double, progress: Double)       //Save to database
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
        Globals.goalsDataObject?.setValue(fundsAlloc, forKey: Constants.CD_GOALS_ALLOCATED_FUNDS)
        Globals.goalsDataObject?.setValue(progress, forKey: Constants.CD_GOALS_PROGRESS)
        
        //4
        do
        {
            try managedContext.save()
            //MARK: - Update chart and goals label in Homepage
            Globals.goals?.amount = amount
            Globals.goals?.dateTo = dateTo
            Globals.goals?.dateFrom = dateFrom
            Globals.goals?.allocatedFunds = fundsAlloc
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
                Methods.saveGoals(dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Methods.setDateTimeToOrigin(date: Date()), moneyToSave: 0, moneyAllocated: 0, progress: 0)
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
        let dateComponent:DateComponents = Methods.getDayDifference(from: Globals.dateTracker!, to: Globals.goals!.dateTo!)
        Globals.labGoalDayLeft?.text = String(dateComponent.day!)
    }
    public static func saveGoalProgress(amount: Double)
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
        Globals.goalsDataObject?.setValue(amount, forKey: Constants.CD_GOALS_PROGRESS)
        
        //4
        do
        {
            try managedContext.save()
            //Update chart in Homepage
            Globals.goals?.progress = amount
   //         Methods.updateChartData()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func updateGoalProgress()
    {
        let yesterdaySurplus:Double = Methods.calculateSurplus(recommendedSpending: Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_REC_SPENDING) as! Double, moneySpent: Globals.fundsSpent)
        let dailyGoalSavings:Double = (Globals.goals?.amount)!/Double(Methods.getDayDifference(from: Globals.goals?.dateFrom ?? Date(), to: Globals.goals?.dateTo ?? Date()).day ?? 0)
        let goalIncreaseYesterday:Double = dailyGoalSavings + yesterdaySurplus
        var goalProgressTotal:Double = Globals.goals!.progress
        goalProgressTotal += goalIncreaseYesterday
        if goalProgressTotal < 0
        {
            Methods.saveGoalProgress(amount: 0)
            Methods.saveSurplus(surplus: goalProgressTotal)
        }
        else
        {
            Methods.saveGoalProgress(amount: goalProgressTotal)
            Methods.saveSurplus(surplus: 0)
        }
    }
    public static func goalIsAchieved() -> Bool
    {
        return Globals.goals!.progress >= Globals.goals!.amount
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
    public static func updateDateTracker()
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
        Globals.fundsDataObject?.setValue(Methods.setDateTimeToOrigin(date: Date()), forKey: Constants.CD_FUNDS_DATE_TRACKER)
        
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
    public static func checkDateTracker()
    {
        guard let _ = Globals.dateTracker else
        {
            Globals.dateTracker = Methods.setDateTimeToOrigin(date: Date())
            return
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
    public static func getWishlistDictionary() -> Dictionary<Int, Dictionary<Int, Dictionary<Int, [WishlistItem]>>>
    {
        let wishlists = Globals.wishlists
        var wishlistDictionary = Dictionary<Int, Dictionary<Int, Dictionary<Int, [WishlistItem]>>>()
        for i in 0..<wishlists.count
        {
            let wishlist = wishlists[i]
            let date:Date = wishlist.date!

            if (wishlistDictionary[Methods.getYearComponent(date: date)] == nil)
            {
                wishlistDictionary[Methods.getYearComponent(date: date)] = Dictionary<Int, Dictionary<Int, [WishlistItem]>>()
            }
            if (wishlistDictionary[Methods.getYearComponent(date: date)]![Methods.getMonthComponent(date: date)] == nil)
            {
                wishlistDictionary[Methods.getYearComponent(date: date)]![Methods.getMonthComponent(date: date)] = Dictionary<Int, [WishlistItem]>()
            }
            if (wishlistDictionary[Methods.getYearComponent(date: date)]![Methods.getMonthComponent(date: date)]![Methods.getDayComponent(date: date)] == nil)
            {
                wishlistDictionary[Methods.getYearComponent(date: date)]![Methods.getMonthComponent(date: date)]![Methods.getDayComponent(date: date)] = [WishlistItem]()
            }
            
            wishlistDictionary[Methods.getYearComponent(date: date)]![Methods.getMonthComponent(date: date)]![Methods.getDayComponent(date: date)]!.append(wishlist)
        }
        return wishlistDictionary
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
    public static func getRecommendedSpending(allocatedFunds funds: Double, goal:Double, timeDurationInDays duration:Int, surplus: Double) -> Double
    {
        if (duration <= 0)
        {
            return 0
        }
        else
        {
            let maxAllocatedFunds:Double = funds/Double(duration)
            let eachDaySave:Double = goal/Double(duration)
            let surplusDivision:Double = surplus/Double(duration)       //Nyicil
            
     //       print("\(maxAllocatedFunds) - \(eachDaySave) + \(surplus) = \(maxAllocatedFunds - eachDaySave + surplus)")
            
            if (surplus < 0)
            {
                return maxAllocatedFunds - eachDaySave + surplusDivision    //Nyicil
            }
            else
            {
                return maxAllocatedFunds - eachDaySave          //No need nyicil
            }
        }
    }
    public static func getRecommendedSpending() -> Double
    {
        return Methods.getRecommendedSpending(allocatedFunds: Globals.goals?.allocatedFunds ?? 0,
                                              goal: Globals.goals?.amount ?? 0,
                                              timeDurationInDays: Methods.getDayDifference(from: Globals.goals?.dateFrom ?? Date(), to: Globals.goals?.dateTo ?? Date()).day ?? 0,
                                              surplus: Methods.getSurplus())
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
        if amount<0
        {
            Globals.labRecSpending?.text = String(format: "%0.0f", 0)
        }
        else
        {
            Globals.labRecSpending?.text = String(format: "%0.0f", amount)
        }
    }
    public static func checkRecommendedSpending()
    {
        guard let _ = Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_REC_SPENDING) else
        {
            Methods.saveRecommendedSpending(recommendedSpending: 0)
            return
        }
    }
    
    //MARK: - Manage Achievements
    public static func saveAchievement(details:String, amount:Double, dateFrom:Date, dateTo:Date, achieved:Bool)     //New Entry
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
        let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_ACHIEVEMENT, in: managedContext)
        
        let achievement = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        achievement.setValue(details, forKey: Constants.CD_ACHIEVEMENT_DETAILS)
        achievement.setValue(amount, forKey: Constants.CD_ACHIEVEMENT_AMOUNT)
        achievement.setValue(dateFrom, forKey: Constants.CD_ACHIEVEMENT_DATE_FROM)
        achievement.setValue(dateTo, forKey: Constants.CD_GOALS_DATE_TO)
        achievement.setValue(achieved, forKey: Constants.CD_ACHIEVEMENT_ACHIEVED)
        achievement.setValue(0, forKey: Constants.CD_ACHIEVEMENT_PROGRESS)
        
        //4
        do
        {
            try managedContext.save()
            Globals.achievements.append(achievement as! Achievement)
            
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    public static func loadAchievements()
    {
        var achievements: [Achievement] = []

        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITY_ACHIEVEMENT)
        
        //3
        do
        {
            achievements = try managedContext.fetch(fetchRequest) as! [Achievement]
//         print("Array expeneses data size: \(expensesData.count)")
            if (achievements.count > 0)
            {
                Globals.achievements = achievements
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    public static func updateAchievement(achievement:Achievement, achieved:Bool)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        
        achievement.setValue(achieved, forKey: Constants.CD_ACHIEVEMENT_ACHIEVED)
        
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
    public static func resetAchievementDuration(achievement:Achievement, startDate:Date)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let range:DateComponents = Methods.getDayDifference(from: achievement.dateFrom!, to: achievement.dateTo!)
        achievement.setValue(startDate, forKey: Constants.CD_ACHIEVEMENT_DATE_FROM)
        let dateTo = Calendar.current.date(byAdding: .day, value: range.day!, to: achievement.dateTo!)
        achievement.setValue(dateTo, forKey: Constants.CD_ACHIEVEMENT_DATE_TO)
        
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
    public static func setAchievementProgress(achievement:Achievement, progress:Double)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        
        achievement.setValue(progress, forKey: Constants.CD_ACHIEVEMENT_PROGRESS)
        
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
    public static func addAchievementsProgress(amount: Double)
    {
        for achievement in Globals.achievements
        {
            Methods.setAchievementProgress(achievement: achievement, progress: achievement.progress + amount)
            if achievement.progress >= achievement.amount
            {
                Methods.updateAchievement(achievement: achievement, achieved: true)
            }
        }
    }
    public static func getAchievedAchievements() -> [Achievement]
    {
        var achievements:[Achievement] = [Achievement]()
        
        for achievement in Globals.achievements
        {
            if achievement.achieved
            {
                achievements.append(achievement)
            }
        }
        
        return achievements
    }
    public static func getPendingAchievements() -> [Achievement]
    {
        var achievements:[Achievement] = [Achievement]()
        
        for achievement in Globals.achievements
        {
            if !achievement.achieved
            {
                achievements.append(achievement)
            }
        }
        
        return achievements
    }
    public static func getAchievedAchievement(dateFrom: Date, dateTo:Date) -> [Achievement]
    {
        var achievements:[Achievement] = [Achievement]()
        
        for achievement in Methods.getAchievedAchievements()
        {
            if (dateFrom <= achievement.dateFrom! && achievement.dateFrom! <= dateTo)
            {
                achievements.append(achievement)
            }
        }
        
        return achievements
    }
    public static func puriftyAchievements(dateLimit: Date)        //Resets achievements not achieved beyond the deadline
    {
        for achievement in Methods.getPendingAchievements()
        {
            if achievement.dateTo! > dateLimit
            {
                if !achievement.achieved
                {
                    Methods.setAchievementProgress(achievement: achievement, progress: 0)
                    Methods.resetAchievementDuration(achievement: achievement, startDate: dateLimit)
                }
            }
        }
    }
    public static func deleteAllAchievements()     //Delete All achievements
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
            for achievement in Globals.achievements
            {
                try managedContext.delete(achievement)
            }
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Notifications
    public static func displayDailyMoneySavedNotification(notifications: Notifications, amount:Double)
    {
        let title:String = "Yesterday you saved..."
        if (amount == 0)
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_MONEY_SAVED, title: title, body:"Sadly, you did not save any money yesterday")
        }
        else if (amount < 0)
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_MONEY_SAVED, title: title, body:"Sadly, you did not save any money yesterday. In fact, you are now in debt :(")
        }
        else
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_MONEY_SAVED, title: title, body:"Congratulations, you saved Rp \(amount) yesterday!")
        }
    }
    public static func displayGoalProgressNotification(notifications: Notifications, progress:Double, goalTotal:Double)
    {
        let percentage:Double = progress/goalTotal
        let title:String = "Your goal progress"
        if percentage <= 25
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_GOAL_PROGRESS, title: title, body: "Your goal is \(percentage)% complete. Let's increase that number!")
        }
        else if percentage >= 50 && percentage <= 55
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_GOAL_PROGRESS, title: title, body: "You're halfway there! Keep it up~")
        }
        else if percentage >= 85 && percentage <= 95
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_GOAL_PROGRESS, title: title, body: "You're almost there! Finish this!!!")
        }
        else
        {
            notifications.scheduleNotification(notificationType: Constants.NOTIFICATION_GOAL_PROGRESS, title: title, body: "You made it! You saved Rp \(goalTotal), congratulations!")
        }
    }
    
    //MARK: - Manage Charts
    public static func updateChartData()
    {
        Globals.goalsComplete.value = Globals.goals!.progress
        Globals.goalsIncomplete.value = Globals.goals!.amount-Globals.goals!.progress
        if (Globals.goalsIncomplete.value < 0)
        {
            Globals.goalsIncomplete.value = 0
        }
        let chartDataSet = PieChartDataSet(entries: Globals.goalsProgress, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        var colors = [UIColor]()
        if Methods.goalIsAchieved()
        {
            colors = [Constants.COLOR_CHART_GOAL_REACHED, Constants.COLOR_CHART_GOAL_LEFT]
        }
        else
        {
            colors = [Constants.COLOR_CHART_GOAL_PROGRESS, Constants.COLOR_CHART_GOAL_LEFT]
        }
        chartDataSet.colors = colors as! [NSUIColor]
        
        Globals.pieChart!.data = chartData
    }
}
