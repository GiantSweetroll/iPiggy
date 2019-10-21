//
//  Expenses.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import CoreData

public class Expenses: NSManagedObject, Identifiable
{
    @NSManaged public var category:String?
    @NSManaged public var info:String?
//    @NSManaged public var cost:Double?
    @NSManaged public var date:Date?
}

extension Expenses
{
    static func getAllExpenses() -> NSFetchRequest<Expenses>
    {
        let request: NSFetchRequest<Expenses> = Expenses.fetchRequest() as! NSFetchRequest<Expenses>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
