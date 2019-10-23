//
//  EditBudgetVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit
import CoreData

class EditFundsVC: UIViewController
{
    //MARK: Storyboard Elements
    @IBOutlet weak var tfEditFunds: UITextField!
    
    //MARK: - Variables
    var trackedFunds:NSManagedObject?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dismiss(animated: true)
        view.isUserInteractionEnabled = true
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let str:String = self.tfEditFunds.text ?? "0"
        self.save(funds: Double(str)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    //MARK: - Database Operations
    func save(funds:Double)     //Save to database
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
        trackedFunds?.setValue(funds, forKey: Constants.CD_FUNDS_TOTAL)
        
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CD_ENTITY_FUNDS)
        
        //3
        do
        {
            var array = try managedContext.fetch(fetchRequest)
            if (array.count > 0)
            {
                self.trackedFunds = array.last
            }
            else
            {
                let entity = NSEntityDescription.entity(forEntityName: Constants.CD_ENTITY_FUNDS, in: managedContext)
                       
                self.trackedFunds = NSManagedObject(entity: entity!, insertInto: managedContext)
                self.save(funds: 0)
            }
            self.tfEditFunds.text = self.trackedFunds?.value(forKey: Constants.CD_FUNDS_TOTAL) as? String
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
