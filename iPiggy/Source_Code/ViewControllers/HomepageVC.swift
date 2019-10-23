//
//  ViewController.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 16/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class HomepageVC: UIViewController
{
    //MARK: Storyboard Elements
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelExpenses: UILabel!
    @IBOutlet weak var labelGoalAmount: UILabel!
    @IBOutlet weak var labelRecSpending: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialization
        self.labelBudget.text = Methods.appendCurrency(string: "0")
        self.labelExpenses.text! = "0"
        self.labelGoalAmount.text = Methods.appendCurrency(string: "0")
        Globals.labFunds = self.labelBudget
        Globals.labRecSpending = self.labelRecSpending
        Methods.loadFunds()
        Methods.updateHomepageFundsLabel(funds: Globals.funds)
        self.labelDate.text = Globals.dateFormatter.string(from: Date())
    }
}
