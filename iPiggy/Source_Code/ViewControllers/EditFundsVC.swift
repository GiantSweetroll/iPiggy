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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        dismiss(animated: true)
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
        Methods.saveFunds(funds: Double(str)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    //MARK: - Database Operations
    override func viewWillAppear(_ animated: Bool)   //Retrieve from database
    {
        super.viewWillAppear(animated)
        
        self.tfEditFunds.text = String(format: "%0.0f", Globals.funds)
    }
}
