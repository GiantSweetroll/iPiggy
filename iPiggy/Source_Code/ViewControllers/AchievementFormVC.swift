//
//  AchievementForm.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class AchievementFormVC: UIViewController
{
    //MARK: Storyboard Elements
    @IBOutlet weak var tfWish: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    
    //MARK: - Variables
    lazy var datePicker:UIDatePicker =
        {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            
            return picker
    }()
    var achieved:Bool?
    
    //MARK: - Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        dismiss(animated: true)
        view.isUserInteractionEnabled = true
        self.tfDate.inputView = self.datePicker
    }
    
    //MARK: - Methods
    @objc func datePickerChanged(_ sender:UIDatePicker)
    {
        self.tfDate.text = Globals.dateFormatFull.string(from: sender.date)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        let name:String = self.tfWish.text ?? ""
        let value:Double = Double(self.tfValue.text ?? "0")!
        let date:Date = self.datePicker.date
        
        Methods.saveWishlist(name: name, cost: value, date: date, achieved: self.achieved ?? false)
        navigationController?.popViewController(animated: true)
    }
}
