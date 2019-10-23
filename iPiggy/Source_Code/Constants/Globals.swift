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
    public static var histories:[History]=[]
    public static var labFunds:UILabel?
    public static var labRecSpending:UILabel?
    public static var fundsDataObject:NSManagedObject?
    public static var funds:Double = 0
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
}
