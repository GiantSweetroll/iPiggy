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
        self.dateFromPicker.minimumDate = Date()
        self.dateToPicker.minimumDate = Date()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let dateFrom:Date = Methods.setDateTimeToOrigin(date: self.dateFromPicker.date)
        let dateTo:Date = Methods.setDateTimeToOrigin(date: self.dateToPicker.date)
        if (dateFrom <= dateTo)
        {
            let amount = Double(self.amount.text ?? "0")!
            
            Methods.saveGoals(dateFrom: dateFrom, dateTo: dateTo, amount: amount)
            dismiss(animated: true, completion: nil)
        }
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
        self.dateFrom?.text = Globals.dateFormatFull.string(from: Globals.goals!.dateFrom ?? Date())
        self.dateTo?.text = Globals.dateFormatFull.string(from: Globals.goals!.dateTo!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    @objc func datePickerChanged(_ sender:UIDatePicker)
    {
        if (sender == self.dateFromPicker)
        {
            self.dateFrom.text = Globals.dateFormatFull.string(from: sender.date)
        }
        else if (sender == self.dateToPicker)
        {
            self.dateTo.text = Globals.dateFormatFull.string(from: sender.date)
        }
    }
}
