//
//  History.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation

class History
{
    var category:String?
    var description:String?
    var amount:Double?
    var date:Date?
    
    init(category:String, description:String, amount:Double, date:Date)
    {
        self.category = category
        self.description = description
        self.amount = amount
        self.date = date
    }
}
