//
//  AddExpensesVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit
import CoreData

class AddExpensesVC: UIViewController
{
    //MARK: - Storyboard Elements
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var category: UISegmentedControl!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var butBack: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dismiss(animated: true, completion: nil)
        view.isUserInteractionEnabled = true
    }
    
    //MARK: - Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    //MARK: - Database Operations
    func save(category: String, description:String, amount: Double, date:Date)
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
            //MARK: - Add to history here
            
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let category:String = self.category.titleForSegment(at: self.category.selectedSegmentIndex)!
        let info:String = self.tfDescription.text!
        let amount:Double = Double(self.tfAmount.text!)!
        let date:Date = self.date.date
        
        //Waiting for date
        self.save(category: category, description: info, amount: amount, date: date)
    
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
