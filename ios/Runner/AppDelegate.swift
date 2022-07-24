import UIKit
import Flutter
import Photos
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "sample.flutter.dev/intentPath",
                                                    binaryMessenger: controller.binaryMessenger)
      
          channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              if(call.method == "getIntentPath"){
                          guard let uri = (call.arguments as? Dictionary<String, String>)?["uri"] else {
                              result(FlutterError(code: "assertion_error", message: "uri is required.", details: nil))
                              return
                          }
                          if (uri.starts(with: "file://") || uri.starts(with: "/var/mobile/Media") || uri.starts(with: "/private/var/mobile")) {
                              result( uri.replacingOccurrences(of: "file://", with: ""))
                              return
                          }
                          let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [uri], options: .none).firstObject
                          if(phAsset == nil) {
                              result(nil)
                              return
                          }
                          let editingOptions = PHContentEditingInputRequestOptions()
                          editingOptions.isNetworkAccessAllowed = true
                          phAsset!.requestContentEditingInput(with: editingOptions) { (input, _) in
                              let url = input?.fullSizeImageURL?.absoluteString.replacingOccurrences(of: "file://", with: "")
                              result(url)
                          }
                      }
     })
      
      
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// import UIKit
// import Flutter

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
// override func application(
// _ application: UIApplication,
// didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
// }

// override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//     var drawingFilename = ""
//     do {
//         let isAcccessing = url.startAccessingSecurityScopedResource()
//         var error: Error? = nil
//         let path = url.path
        
//         let string = try String(contentsOf: url)
//         drawingFilename = (url.path as NSString).lastPathComponent
//         print(drawingFilename)
       
//         let filename = getDocumentsDirectory().appendingPathComponent(drawingFilename)

//         do {
//             try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
//         } catch {
//             // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//         }
//         if isAcccessing {
//             url.stopAccessingSecurityScopedResource()
//         }
//       if #available(iOS 9.0, *) {
//           return super.application(app, open: filename, options: options)
//       } else {
//          return false
//       }
//     } catch {
//         print("Unable to load data: \(error)")
//         return false
//     }

    
      
// }

// func getDocumentsDirectory() -> URL {
//     let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//     return paths[0]
// }
// }