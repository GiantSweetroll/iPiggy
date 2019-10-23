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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dismiss(animated: true)
    }
    
    //MARK: - Methods
    @objc func datePickerChanged(_ sender:UIDatePicker)
    {
        self.dateFrom.text = Globals.dateFormatFull.string(from: sender.date)
    }
}
