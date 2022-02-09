//
//  NotificationManager.swift
//  ToDoProject
//
//  Created by ozgun on 8.02.2022.
//

import Foundation
import UserNotifications
import UIKit

protocol NotificationManagerProtocol {
    var notifications : [NotificationItem] { get set }
    func schedule(with id: String, complation: @escaping (Bool) -> Void)
    func deleteNotification(with id: String, complationHandler: @escaping (Bool) -> Void)
}

struct NotificationItem {
    var id : String
    var title : String
    var description : String
    var date: Date
}

class NotificationManager: NotificationManagerProtocol{
    
    var notifications = [NotificationItem]()

    let notificationCenter = UNUserNotificationCenter.current()
    
    //MARK: - Ask for permission

    private func requestAuthorization(with id: String, complation: @escaping (Bool) -> Void){
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { permission, error in
            if permission == true && error == nil {
                self.scheduleNotification(with: id) { onSuccess in
                    complation(onSuccess)
                }            }
        }
    }
    
    //MARK: - main call

    func schedule(with id: String, complation: @escaping (Bool) -> Void){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(with: id) { onSuccess in
                    complation(onSuccess)
                }
            case .authorized, .provisional:
                self.scheduleNotification(with: id) { onSuccess in
                    complation(onSuccess)
                }
            default :
                self.requestAuthorization(with: id) { onSuccess in
                    complation(onSuccess)
                }
                print("Izin konusunda handle edilmemis durum")
            }
        }
    }
    
    //MARK: - schedule Notification

    private func scheduleNotification(with id: String, complationHandler: @escaping (Bool) -> Void) {
        let notify = notifications.filter { $0.id == id }
        DispatchQueue.main.async {
            let content = UNMutableNotificationContent()
            content.title = notify[0].title
            content.body = notify[0].description
            
            let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notify[0].date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { error in
                if error != nil {
                    print("Error with notification center: \(error!.localizedDescription)")
                    return
                }
                print("notification successfull")
                complationHandler(true)
            }
        }
    }
    //MARK: - delete notification

    func deleteNotification(with id: String, complationHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
            self.notifications = self.notifications.filter { $0.id != id }
            complationHandler(true)
        }
    }
}
