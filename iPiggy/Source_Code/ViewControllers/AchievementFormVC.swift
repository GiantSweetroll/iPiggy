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
    var newEntry:Bool?
    var wishlistItem:WishlistItem!
    
    //MARK: - Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        self.tfDate.inputView = self.datePicker
  //      print("Is new entry? \(self.newEntry)")
        if (self.newEntry == nil || self.newEntry!)
        {
            self.achieved = true
            self.newEntry = false
            self.tfDate.text = Globals.dateFormatFull.string(from: Date())
        }
        else
        {
            //Not new entry
            self.tfWish.text = self.wishlistItem.name
            self.tfValue.text = String(format:"%0.0f", self.wishlistItem.cost)
            self.tfDate.text = Globals.dateFormatFull.string(from: self.wishlistItem.date!)
            self.achieved = self.wishlistItem.achieved
            self.datePicker.date = self.wishlistItem.date!
        }
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
        
        let isNewEntry = self.newEntry ?? true
        
        if (isNewEntry)
        {
            Methods.saveWishlist(name: name, cost: value, date: date, achieved: self.achieved ?? false)
        }
        else
        {
            Methods.saveWishlist(wishlist: self.wishlistItem, name: name, cost: value, date: date, achieved: self.achieved ?? false)
        }
        navigationController?.popViewController(animated: true)
    }
}
