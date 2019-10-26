//
//  ViewController.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 16/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit
import Charts

class HomepageVC: UIViewController
{
    //MARK: Storyboard Elements
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelExpenses: UILabel!
    @IBOutlet weak var labelGoalAmount: UILabel!
    @IBOutlet weak var labelRecSpending: UILabel!
    @IBOutlet weak var labelGoalDayLeft: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialization
        Methods.checkDateTracker()
        self.labelBudget.text = Methods.appendCurrency(string: "0")
        self.labelExpenses.text! = "0"
        self.labelGoalAmount.text = Methods.appendCurrency(string: "0")
        Globals.labFunds = self.labelBudget
        Globals.labRecSpending = self.labelRecSpending
        Globals.labGoals = self.labelGoalAmount
        Globals.labGoalDayLeft = self.labelGoalDayLeft
        Globals.labExpensesToday = self.labelExpenses
        Globals.histories = []
        Globals.fullListOfCalendarDays = Methods.generateYearlyCalendarArray(year: Methods.getYearComponent(date: Date()))
        Methods.loadFunds()
        Methods.updateHomepageFundsLabel(funds: Globals.funds)
        Methods.updateHomepageFundsSpentLabel(fundsSpent: Globals.fundsSpent)
        Methods.loadGoals()
        Methods.updateHomepageGoalsLabel(goals: Globals.goals?.amount ?? 0)
        Methods.updateHomepageGoalsDayLeftLabel()
  //      Methods.addDayLabelsToCalendarArray()
        self.labelDate.text = Globals.dateFormatFull.string(from: Date())
        if (!Methods.isSameDate(date1: Globals.dateTracker!, date2: Date()))
        {
            Methods.updateDateTracker()
            Methods.saveMoneySpent(value: 0)        //Resets daily money spent
            //TODO calculate surplus from previous day
        }
        
        //Configure pie chart
        Globals.pieChart = self.pieChart
        Globals.goalsComplete.value = 0
        Globals.goalsIncomplete.value = Globals.goals?.amount ?? 0
        Globals.goalsProgress = [Globals.goalsComplete, Globals.goalsIncomplete]
        Globals.pieChart!.drawEntryLabelsEnabled = false
        
        //Calculate recommended Spending
        Methods.saveRecommendedSpending(recommendedSpending: Double(Methods.getRecommendedSpendingNoDecimal()))
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        Methods.updateChartData()
   //     print("Hello worldd")
    }
}
