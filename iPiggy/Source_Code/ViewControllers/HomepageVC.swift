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
    
    //Variables
    var notifications:Notifications = Notifications()
    
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
        Globals.fullListOfCalendarDays = Methods.generateYearlyCalendarArray(year: Methods.getYearComponent(date: Globals.dateTracker!))
        Globals.currentYearlyCalendarYearDisplayed = Methods.getYearComponent(date: Globals.dateTracker!)
        Methods.loadFunds()
        Methods.loadAchievements()
        Methods.checkSurplus()
        Methods.checkRecommendedSpending()
        Methods.updateHomepageFundsLabel(funds: Globals.funds)
        Methods.updateHomepageFundsSpentLabel(fundsSpent: Globals.fundsSpent)
        Methods.loadGoals()
        Methods.updateHomepageGoalsLabel(goals: Globals.goals?.amount ?? 0)
        Methods.updateHomepageGoalsDayLeftLabel()
  //      Methods.addDayLabelsToCalendarArray()
        self.labelDate.text = Globals.dateFormatFull.string(from: Date())
        Methods.loadWishlists()
        Globals.wishlistDictionary = Methods.getWishlistDictionary()
        if (!Methods.isSameDate(date1: Globals.dateTracker!, date2: Date()))
        {
            Methods.updateDateTracker()
            Methods.addAchievementsProgress(amount: Methods.getMoneySavedYesterday())
            Methods.updateGoalProgress()
            Methods.saveSurplus(surplus: Methods.getSurplus() + Methods.calculateSurplus(recommendedSpending: Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_REC_SPENDING) as! Double, moneySpent: Globals.fundsDataObject?.value(forKey: Constants.CD_FUNDS_EXPENSE) as! Double))
            Methods.saveMoneySpent(value: 0)        //Resets daily money spent
        }
        
        //Configure pie chart
        Globals.pieChart = self.pieChart
        Globals.goalsComplete.value = 0
        Globals.goalsIncomplete.value = Globals.goals?.amount ?? 0
        Globals.goalsProgress = [Globals.goalsComplete, Globals.goalsIncomplete]
        Globals.pieChart!.drawEntryLabelsEnabled = false
        
        //Calculate recommended Spending
        Methods.saveRecommendedSpending(recommendedSpending: Double(Methods.getRecommendedSpendingNoDecimal()))
        
        notifications.scheduleNotification(notificationType: "iPiggy messages")
        
        //This is done by cen
        
         navigationController?.navigationBar.barTintColor = UIColor(red: 255, green: 135, blue: 103, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        Methods.updateChartData()
   //     print("Hello worldd")
    }
    
    private func addAchievements()      //Already run
    {
        Methods.saveAchievement(details: "You saved Rp 10.000 in a day!", amount: 10000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .day, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 25.000 in a day!", amount: 25000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .day, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 50.000 in a day!", amount: 50000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .day, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 50.000 in a week!", amount: 50000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .day, value: 7, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 100.000 in a week!", amount: 100000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .day, value: 7, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 100.000 in a month!", amount: 100000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .month, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 250.000 in a month!", amount: 250000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .month, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 1.000.000 in a month!", amount: 1000000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .month, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
        Methods.saveAchievement(details: "You saved Rp 2.500.000 in a month!", amount: 2500000, dateFrom: Methods.setDateTimeToOrigin(date: Date()), dateTo: Calendar.current.date(byAdding: .month, value: 1, to: Methods.setDateTimeToOrigin(date: Date()))!, achieved: false)
    }
}
