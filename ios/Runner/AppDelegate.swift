import Flutter
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Set the callback for FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // Set UNUserNotificationCenter delegate to self
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // Register plugins with the Flutter engine
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
