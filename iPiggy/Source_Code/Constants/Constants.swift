//
//  Constants.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

struct Constants
{
    public static let CURRENCY = "Rp"
    public static let CD_ENTITY_ACHIEVEMENT = "Achievement"
    public static let CD_ACHIEVEMENT_ACHIEVED = "achieved"
    public static let CD_ACHIEVEMENT_AMOUNT = "amount"
    public static let CD_ACHIEVEMENT_DATE_FROM = "dateFrom"
    public static let CD_ACHIEVEMENT_DATE_TO = "dateTo"
    public static let CD_ACHIEVEMENT_DETAILS = "details"
    public static let CD_ACHIEVEMENT_PROGRESS = "progress"
    public static let CD_FUNDS_TOTAL = "funds"
//    public static let CD_FUNDS_LEFT = "fundsLeft"
    public static let CD_FUNDS_REC_SPENDING = "recSpending"
    public static let CD_FUNDS_EXPENSE = "expense"
    public static let CD_FUNDS_DATE_TRACKER = "dateTracker"
    public static let CD_FUNDS_SURPLUS = "surplus"
    public static let CD_ENTITY_FUNDS = "Funds"
    public static let CD_ENTITY_EXPENSES = "Expenses"
    public static let CD_EXPENSES_CATEGORY = "category"
    public static let CD_EXPENSES_DESCRIPTION = "info"
    public static let CD_EXPENSES_AMOUNT = "cost"
    public static let CD_EXPENSES_DATE = "date"
    public static let CD_ENTITIY_GOALS = "Goal"
    public static let CD_GOALS_DATE_FROM = "dateFrom"
    public static let CD_GOALS_DATE_TO = "dateTo"
    public static let CD_GOALS_AMOUNT = "amount"
    public static let CD_GOALS_PROGRESS = "progress"
    public static let CD_GOALS_ALLOCATED_FUNDS = "allocatedFunds"
    public static let CD_ENTITY_WISHLIST = "WishlistItem"
    public static let CD_WISHLIST_NAME = "Name"
    public static let CD_WISHLIST_DATE = "date"
    public static let CD_WISHLIST_COST = "cost"
    public static let CD_WISHLIST_ACHIEVED = "achieved"
    public static let TVC_HISTORY = "expenses"
    public static let TVC_WISHLIST = "cellWishlist"
    public static let TVC_ACHIEVEMENT = "achievementCell"
    public static let TVC_YEARLY_ACHIEVEMENT = "yearlyAchievementCell"
    public static let TVC_MONTH_WISHLIST = "tableCell"
    public static let TVC_WISHLIST_MONTH_CALENDAR = "cellDetails"
    public static let SEGUE_WISHLIST_DETAILS = "wishlistDetails"
    public static let SEGUE_WISHLIST_ADD = "addWishlist"
    public static let SEGUE_WISHLIST_DETAILS_TO_FORM = "detailToForm"
    public static let SEGUE_WISHLIST_FORM_TO_MAIN = "formToMain"
    public static let SEGUE_CALENDAR_YEAR_TO_MONTH = "yearToMonth"
    public static let SEGUE_CALEDAR_MONTH_TO_WISHLIST_DETAIL = "monthToWishlistDetails"
    public static let CVC_CALENDAR_YEARLY_DAILY_CELL = "dailyCell"
    public static let CVC_CALENDAR_YEARLY_MONTHLY_CELL = "monthCell"
    public static let CVC_CALENDAR_MONTHLY_CELL = "dayCell"
    public static let CVC_CALENDAR_MONTHLY_DAY_LABEL_CELL = "dayLabelCell"
    public static let MONTHS: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    public static let MONTHS_SHORT:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    public static let DAYS: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    public static let NOTIFICATION_DAILY_SPENDING = "dailySpending"
    public static let NOTIFICATION_GOAL_PROGRESS = "goalProgress"
    public static let NOTIFICATION_EXPENSES_WARNING = "expensesWarning"
    public static let NOTIFICATION_MONEY_SAVED = "moneySaved"
    public static let COLOR_CHART_GOAL_PROGRESS:UIColor = UIColor(red: 0.42, green: 0.46, blue: 1.00, alpha: 1)
//    public static let COLOR_CHART_GOAL_PROGRESS:UIColor = UIColor.purple
    public static let COLOR_CHART_GOAL_LEFT:UIColor = UIColor.gray
    public static let COLOR_CHART_GOAL_REACHED:UIColor = UIColor.green
}
