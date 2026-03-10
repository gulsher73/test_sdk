import Flutter
import UIKit

/// TestSDK - Flutter-based Hello World SDK
/// Host apps use this class to show the Flutter Hello World screen.
public class TestSDK {

    private static var flutterEngine: FlutterEngine?

    /// Call once at app launch (e.g. in AppDelegate.didFinishLaunching)
    public static func initialize() {
        let engine = FlutterEngine(name: "test_sdk_engine")
        engine.run()
        flutterEngine = engine
    }

    /// Present the Hello World Flutter screen from any UIViewController.
    /// - Parameters:
    ///   - viewController: The presenting UIViewController
    ///   - animated: Whether to animate the presentation (default: true)
    public static func showHelloWorld(from viewController: UIViewController, animated: Bool = true) {
        guard let engine = flutterEngine else {
            assertionFailure("TestSDK: Call TestSDK.initialize() before showing the screen.")
            return
        }
        let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        flutterVC.modalPresentationStyle = .fullScreen
        viewController.present(flutterVC, animated: animated)
    }
}
