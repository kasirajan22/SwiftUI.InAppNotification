//
//  Home.swift
//  InAppNotification
//
//  Created by Magizhan on 30/10/20.
//

import SwiftUI
import UserNotifications

struct Home: View {
    @StateObject var delegate = NotificationDelegate()
    
    var body: some View {
        Button(action: {
            createNotification()
        }, label: {
            Text("Notify User")
        })
        .onAppear(perform: {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { granted, error in
                
                if let error = error {
                    // Handle the error here.
                }
                print("Authorized")
                // Provisional authorization granted.
            }
            
            
            UNUserNotificationCenter.current().delegate = delegate
        })
        .alert(isPresented: $delegate.alert, content: {
            Alert(title: Text("Message"), message: Text("Reply Button is Pressed !!!"), dismissButton: .destructive(Text("Ok")))
        })
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.subtitle = "Notification From IN-APP"
        //content.categoryIdentifier = "ACTIONS"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "IN-APP", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
//        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
//        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
//        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close,reply], intentIdentifiers: [], options: [])
//
//        UNUserNotificationCenter.current().setNotificationCategories([category])
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("test1")
    }
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var alert = false
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.badge,.sound])
        print("test")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("recived")
        if response.actionIdentifier == "REPLY" {
            print("reply to comment")
            self.alert.toggle()
        }
        completionHandler()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
