//
//  Globals.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Globals
{
    public static var histories:[Expenses]=[]
    public static var wishlists:[WishlistItem]=[]
    public static var labFunds:UILabel?
    public static var labRecSpending:UILabel?
    public static var labGoals:UILabel?
    public static var fundsDataObject:NSManagedObject?
    public static var goalsDataObject:NSManagedObject?
    public static var goals:Goal?
    public static var funds:Double = 0
    public static var isNewAchievement:Bool = false
    public static var dateFormatFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    public static var dateFormatMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
