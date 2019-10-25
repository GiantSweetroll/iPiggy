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
    
    //MARK: - Variables
    var goalsComplete:PieChartDataEntry = PieChartDataEntry(value: 0)
    var goalsIncomplete:PieChartDataEntry = PieChartDataEntry(value: 100)
    var goalsProgress = [PieChartDataEntry]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialization
        if (Globals.dateTracker != Date())
        {
            Methods.updateDateTracker()
            Methods.saveMoneySpent(value: 0)        //Resets daily money spent
        }
        self.labelBudget.text = Methods.appendCurrency(string: "0")
        self.labelExpenses.text! = "0"
        self.labelGoalAmount.text = Methods.appendCurrency(string: "0")
        Globals.labFunds = self.labelBudget
        Globals.labRecSpending = self.labelRecSpending
        Globals.labGoals = self.labelGoalAmount
        Globals.labGoalDayLeft = self.labelGoalDayLeft
        Globals.labFundsSpent = self.labelExpenses
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
        
        //Update pie chart
        self.goalsComplete.value = 0
        self.goalsIncomplete.value = 100
        self.goalsProgress = [self.goalsComplete, self.goalsIncomplete]
    }
    
    //MARK: - Methods
    func updateChartData()
    {
        let chartDataSet = PieChartDataSet(entries: self.goalsProgress, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.blue]
        chartDataSet.colors = colors as! [NSUIColor]
        
        self.pieChart.data = chartData
    }
}
