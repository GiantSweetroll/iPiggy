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
            if (date == Date())
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
        Globals.labFundsSpent?.text =  String(format: "%0.0f", fundsSpent)
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
    public static func saveWishlist(name:String, cost:Double, date:Date, achieved:Bool, indexInDB:Int)     //Existing Entry
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITY_WISHLIST)
        
        //4
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            if (array.count > 0)
            {
                let wishlist:NSManagedObject = NSManagedObject(entity: array[indexInDB].entity, insertInto: managedContext)
                wishlist.setValue(name, forKey: Constants.CD_WISHLIST_NAME)
                wishlist.setValue(cost, forKey: Constants.CD_WISHLIST_COST)
                wishlist.setValue(date, forKey: Constants.CD_WISHLIST_DATE)
                wishlist.setValue(achieved, forKey: Constants.CD_WISHLIST_ACHIEVED)
                try managedContext.save()
            }
            
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Calendar Operations
    public static func getDayDifference(from dateFrom:Date, to dateTo:Date) -> DateComponents
    {
        return Calendar.current.dateComponents([.day], from: dateFrom, to: dateTo)
    }
    public static func generateYearlyCalendarArray() -> [[String]]
    {
        var array:[[String]] = [[]]
        
        
        
        return array
    }
}
