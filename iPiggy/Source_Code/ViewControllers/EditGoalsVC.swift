//
//  EditGoalsVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit
import CoreData

class EditGoalsVC:UIViewController
{
    //IBOutlets
    @IBOutlet weak var dateFrom: UIDatePicker!
    @IBOutlet weak var dateTo: UIDatePicker!
    @IBOutlet weak var amount: UITextField!
    
    //MARK: - Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let dateFrom:Date = self.dateFrom.date
        let dateTo:Date = self.dateTo.date
        var amount:Double = 0
        do
        {
            amount = try Double(self.amount.text!)!
        }
        catch let error as NSError
        {
            print()
            print("Error: \(error), \(error.userInfo)")
            print()
        }
        
        self.save(dateFrom: dateFrom, dateTo: dateTo, amount: amount)
    }
    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Other Methods
    func save(dateFrom: Date, dateTo:Date, amount:Double)       //Save to database
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
        let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITIY_GOALS, in: managedContext)
           
           let expenses = NSManagedObject(entity: entity!, insertInto: managedContext)
           
           //3
        expenses.setValue(dateFrom, forKey: Constants.CD_GOALS_DATE_FROM)
        expenses.setValue(dateTo, forKey: Constants.CD_GOALS_DATE_TO)
        expenses.setValue(amount, forKey: Constants.CD_GOALS_AMOUNT)
           
           //4
           do
           {
               try managedContext.save()
    //           expenses.append(person)
            //MARK: - Update chart and goals label in Homepage
               
           }
           catch let error as NSError
           {
               print("Could not save. \(error), \(error.userInfo)")
           }
       }
    override func viewWillAppear(_ animated: Bool)   //Retrieve from database
    {
        super.viewWillAppear(animated)
        
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
                self.amount.text = array[array.count-1].value(forKey: Constants.CD_GOALS_AMOUNT) as? String
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
