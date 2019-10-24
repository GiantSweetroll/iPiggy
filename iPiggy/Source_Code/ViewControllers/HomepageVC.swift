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
    @IBOutlet weak var labelGoalDayLeft: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialization
        self.labelBudget.text = Methods.appendCurrency(string: "0")
        self.labelExpenses.text! = "0"
        self.labelGoalAmount.text = Methods.appendCurrency(string: "0")
        Globals.labFunds = self.labelBudget
        Globals.labRecSpending = self.labelRecSpending
        Globals.labGoals = self.labelGoalAmount
        Globals.labGoalDayLeft = self.labelGoalDayLeft
        Globals.labFundsSpent = self.labelExpenses
        Globals.histories = []
        Methods.loadFunds()
        Methods.updateHomepageFundsLabel(funds: Globals.funds)
        Methods.updateHomepageFundsSpentLabel(fundsSpent: Globals.fundsSpent)
        Methods.loadGoals()
        Methods.updateHomepageGoalsLabel(goals: Globals.goals?.amount ?? 0)
        Methods.updateHomepageGoalsDayLeftLabel()
        self.labelDate.text = Globals.dateFormatFull.string(from: Date())
        
        if (Globals.dateTracker != Date())
        {
            Methods.updateDateTracker()
            Methods.saveMoneySpent(value: 0)        //Resets daily money spent
        }
        
        let arr:[[String]] = Methods.generateYearlyCalendarArray(year: 2019, firstDayOfTheYear: 3)
        for i in 0..<arr.count
        {
            print(arr[i])
        }
    }
}
