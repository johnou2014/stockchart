//
//  ViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/6.
//

import UIKit

class ViewController: UITabBarController, KSWebSocketDelegate {
    private var socket: KSWebSocket?
    @objc enum NotificationReminder: Int {
      case fiveSeconds = 0
      case oneDay
      case oneWeek
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsettings()
    }
    
    func notificationsettings() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
              print("Yay!")
            } else {
              print("D'oh")
            }
          }
        socket?.activeClose()
        NotificationCenter.default.removeObserver(self)
        print("run ++++++++++ ws ")
        let server       = "ws://easytrade007.com:8080/ws/foobar?subscribe-broadcast&publish-broadcast&echo"
        socket           = KSWebSocket.init()
        //socket?.configureServer(KSSingleton.shared.server.socketServer, isAutoConnect: true)
        socket?.configureServer(server, isAutoConnect: true)
        socket?.delegate = self
        socket?.startConnect()
    }
    func socket(_ socket: KSWebSocket!, didReceivedMessage message: Any!) {
        if let _message = message as? String {
            if let jsonData = _message.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                //print("message =",_message);
                if(_message != "--heartbeat--") {
                    print("new message =",_message)
                    scheduleLocal(reminder: .fiveSeconds, title: _message)
                }
                return;
            }
        }
    }
}
extension ViewController: UNUserNotificationCenterDelegate {
    @objc func scheduleLocal(reminder: NotificationReminder = .fiveSeconds, title: String = "Late wake up call") {
        
      registerCategories() // it is the safest place

      let center = UNUserNotificationCenter.current() // the main center to work with notifications
      // center.removeAllPendingNotificationRequests() // this removes all pending notifications

      // this is the content you are going to send to your notification
      let content = UNMutableNotificationContent()
      content.title = "请卖掉\(title)股票，否则亏死" // the main title
      content.body = "看到信息请及时处理！！" // the main text
      content.categoryIdentifier = "alarm" // this are the custom actions
      content.userInfo = ["customData" : "fizzbuzz"] // this helps to attach custom data to the notification. e.g. an internal ID
      content.sound = UNNotificationSound.default // you can create a custom UNNotificationSound object and attach it to the sound property, or just use the default one

      // get the date components to schedule the time you want your notification
      //var dateComponents = DateComponents()
      //dateComponents.hour = 21 // give the hour
      //dateComponents.minute = 13 // give the minutes
      //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // trigger the notification to your calendar

      let trigger: UNTimeIntervalNotificationTrigger
      // faster test
      switch reminder.rawValue {
      case 0:
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
      case 1:
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
      case 2:
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
      default:
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      }

      // create your notification request - the notification needs an unique identifier
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      // add it to your center
      center.add(request)
    }

    func registerCategories() {
      let center = UNUserNotificationCenter.current()
      center.delegate = self

      let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
      let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: .foreground)
      let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])

      center.setNotificationCategories([category])
    }
}
