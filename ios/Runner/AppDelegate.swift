import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //NOTE Register Plugin
    if let registrar = self.registrar(forPlugin: "FlutterDynamicIconPlusPlugin") {
        FlutterDynamicIconPlusPlugin.register(with: registrar)
    }
    //END NOTE
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
