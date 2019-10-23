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
    @IBOutlet weak var dateFrom: UITextField!
    @IBOutlet weak var dateTo: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    //Variables
    lazy var dateFromPicker:UIDatePicker =
        {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            
            return picker
    }()
    lazy var dateToPicker:UIDatePicker =
        {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            
            return picker
    }()
    
    //MARK: - Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        self.dateFrom.inputView = self.dateFromPicker
        self.dateTo.inputView = self.dateToPicker
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let dateFrom:Date = self.dateFromPicker.date
        let dateTo:Date = self.dateToPicker.date
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
        
        Methods.saveGoals(dateFrom: dateFrom, dateTo: dateTo, amount: amount)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Other Methods
    override func viewWillAppear(_ animated: Bool)   //Retrieve from database
    {
        super.viewWillAppear(animated)
        
        self.amount?.text = String(format: "%0.0f", (Globals.goals?.amount)!)
        self.dateFrom?.text = Globals.dateFormatter.string(from: Globals.goals?.dateFrom ?? Date())
        self.dateTo?.text = Globals.dateFormatter.string(from: Globals.goals?.dateTo ?? Date())
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    @objc func datePickerChanged(_ sender:UIDatePicker)
    {
        if (sender == self.dateFromPicker)
        {
            self.dateFrom.text = Globals.dateFormatter.string(from: sender.date)
        }
        else if (sender == self.dateToPicker)
        {
            self.dateTo.text = Globals.dateFormatter.string(from: sender.date)
        }
    }
}
