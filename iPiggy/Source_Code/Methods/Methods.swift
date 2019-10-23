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
            var array = try managedContext.fetch(fetchRequest)
            if (array.count > 0)
            {
                Globals.fundsDataObject = array.last
            }
            else
            {
                let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
                       
                Globals.fundsDataObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                Methods.saveFunds(funds: 0)
            }
            Globals.funds = Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_TOTAL) as! Double
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
                var array = try managedContext.fetch(fetchRequest)
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
                Globals.goals = Globals.goalsDataObject as! Goal
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
}
