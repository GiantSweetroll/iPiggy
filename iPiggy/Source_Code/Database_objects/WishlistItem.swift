//
//  WishlistItem.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 21/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import CoreData

public class WishlistItem: NSManagedObject, Identifiable
{
 //   @NSManaged var cost:Double?
    @NSManaged var name:String?
    @NSManaged var date:Date?
}

extension WishlistItem
{
    static func getAllWishlistItem() -> NSFetchRequest<WishlistItem>
    {
        let request: NSFetchRequest<WishlistItem> = WishlistItem.fetchRequest() as! NSFetchRequest<WishlistItem>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
