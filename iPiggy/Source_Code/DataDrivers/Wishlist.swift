//
//  Wishlist.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation

class Wishlist
{
    var name:String?
    var date:Date?
    var amount:Double?
    var achieved: Bool?
    
    init(name:String, date:Date, amount:Double, achieved:Bool)
    {
        self.name = name
        self.date = date
        self.amount = amount
        self.setAchieved(achieved: achieved)
    }
    
    //MARK: - Methods
    public func setAchieved(achieved:Bool)
    {
        self.achieved = achieved
    }
}
