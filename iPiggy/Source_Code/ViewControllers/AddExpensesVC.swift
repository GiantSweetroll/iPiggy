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
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var category: UISegmentedControl!
    @IBOutlet weak var butBack: UIButton!
    
    //MARK: - Variables
    lazy var datePicker:UIDatePicker =
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
//        dismiss(animated: true, completion: nil)
        view.isUserInteractionEnabled = true
        self.tfDate.inputView = self.datePicker
    }
    
    //MARK: - Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    @objc func datePickerChanged(_ sender:UIDatePicker)
    {
        self.tfDate.text = Globals.dateFormatter.string(from: sender.date)
 //       self.date = self.datePicker.date
    }
    
    //MARK: - Database Operations
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        if (self.tfDate.text != nil && self.tfAmount.text != nil)
        {
            let category:String = self.category.titleForSegment(at: self.category.selectedSegmentIndex)!
            let info:String = self.tfDescription.text!
            let amount:Double = Double(self.tfAmount.text!)!
            let date:Date = self.datePicker.date
                
            Methods.saveExpenses(category: category, description: info, amount: amount, date: date)
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
