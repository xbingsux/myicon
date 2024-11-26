//NOTE Main File 
import Flutter
import UIKit

public class FlutterDynamicIconPlusPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_dynamic_icon_plus", binaryMessenger: registrar.messenger())
        let instance = FlutterDynamicIconPlusPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "supportsAlternateIcons":
            if #available(iOS 10.3, *) {
                result(UIApplication.shared.supportsAlternateIcons)
            } else {
                result(FlutterError(code: "Unavailable", message: "Not supported", details: nil))
            }
        
        case "getAlternateIconName":
            if #available(iOS 10.3, *) {
                result(UIApplication.shared.alternateIconName)
            } else {
                result(FlutterError(code: "Unavailable", message: "Not supported on iOS versions < 10.3", details: nil))
            }
            
        case "setAlternateIconName":
            if #available(iOS 10.3, *) {
                
                guard let args = call.arguments as? [String: Any],
                let showAlert = args["showAlert"] as? Bool else {
                    result(FlutterError(code: "InvalidArguments", message: "Invalid arguments for setAlternateIconName", details: nil))
                    return
                }
                // iconName อนุญาตให้เป็น nil ได้
                let iconName = args["iconName"] as? String
                
                if !showAlert {
                    let selector = NSSelectorFromString("_setAlternateIconName:completionHandler:")
                    if UIApplication.shared.responds(to: selector) {
                        let methodImplementation = UIApplication.shared.method(for: selector)
                        if let implementation = methodImplementation {
                            typealias SetAlternateIconFunc = @convention(c) (AnyObject, Selector, String?, @escaping (NSError?) -> Void) -> Void
                            let function = unsafeBitCast(implementation, to: SetAlternateIconFunc.self)

                            function(UIApplication.shared, selector, iconName) { error in
                                if let error = error {
                                    result(FlutterError(code: "FailedToSetIcon", message: error.localizedDescription, details: nil))
                                } else {
                                    result(nil)
                                }
                            }
                        } else {
                            result(FlutterError(code: "Unavailable", message: "Private API implementation not found", details: nil))
                        }
                    } else {
                        result(FlutterError(code: "Unavailable", message: "Private API not available", details: nil))
                    }
                } else {
                    UIApplication.shared.setAlternateIconName(iconName) { error in
                        if let error = error {
                            print("Error changing icon: \(error.localizedDescription)")
                            result(FlutterError(code: "FailedToSetIcon", message: error.localizedDescription, details: nil))
                        } else {
                            print("Successfully changed icon to 'christmas'")
                            result(nil)
                        }
                    }
                }
            } else {
                result(FlutterError(code: "Unavailable", message: "Not supported on iOS versions < 10.3", details: nil))
            }
        case "getApplicationIconBadgeNumber":
            result(UIApplication.shared.applicationIconBadgeNumber)
        
        case "setApplicationIconBadgeNumber":
            guard let args = call.arguments as? [String: Any],
                  let badgeNumber = args["badgeNumber"] as? Int else {
                result(FlutterError(code: "InvalidArguments", message: "Invalid arguments for setApplicationIconBadgeNumber", details: nil))
                return
            }
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
                            result(nil)
                        }
                    } else {
                        result(FlutterError(code: "PermissionDenied", message: "Badge permission not granted", details: nil))
                    }
                }
            } else {
                UIApplication.shared.applicationIconBadgeNumber = badgeNumber
                result(nil)
            }
        
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
