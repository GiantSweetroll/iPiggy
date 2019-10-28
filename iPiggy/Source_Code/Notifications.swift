//
//  Notification.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 27/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import Foundation
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate
{
    //MARK: - Variables
    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequest()
    {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options)
        {
            (didAllow, error) in
            if !didAllow
            {
                print("User has declined notifications")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //So that notification can still be received when the application is in the foreground
        completionHandler([.alert, .sound])
    }
    
    func scheduleNotification(notificationType type: String, title: String, body:String)
    {
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Delete Notification Type"
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var trigger:UNNotificationTrigger!
        if (type == Constants.NOTIFICATION_EXPENSES_WARNING)
        {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
        }
        else if (type == Constants.NOTIFICATION_MONEY_SAVED)
        {
            let date = Calendar.current.date(byAdding: .day, value: 1, to:Methods.setDateTimeToOrigin(date: Date()))
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date!)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        }
        else if (type == Constants.NOTIFICATION_GOAL_PROGRESS)
        {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*60*3600, repeats: false)
        }
        else if (type == Constants.NOTIFICATION_DAILY_SPENDING)
        {
            let date = Calendar.current.date(byAdding: .day, value: 1, to:Methods.setDateTimeToOrigin(date: Date()))
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date!)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        }
        else
        {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
}
