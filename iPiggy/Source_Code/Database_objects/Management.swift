//
//  Management.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import CoreData

public class Management: NSManagedObject, Identifiable
{
    @NSManaged var dateFrom:Date?
    @NSManaged var dateTo:Date?
//    @NSManaged var funds:Double?
 //   @NSManaged var moneyLeft:Double?
//    @NSManaged var endGoal:Double?
//    @NSManaged var progressGoal:Double?
}

extension Management
{
    static func getAllManagement() -> NSFetchRequest<Management>
    {
        let request: NSFetchRequest<Management> = Management.fetchRequest() as! NSFetchRequest<Management>
        
        let sortDescriptor = NSSortDescriptor(key: "dateFrom", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
