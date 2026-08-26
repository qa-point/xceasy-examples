import UIKit

/// Starts the standalone UIKit example without a storyboard or SwiftUI host.
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    /// Confirms application startup before UIKit creates its window scene.
    ///
    /// - Parameters:
    ///   - application: Application being launched.
    ///   - launchOptions: Optional launch context supplied by UIKit.
    /// - Returns: Always `true` so UIKit can connect the scene.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UITestStateReset.performIfRequested()
        return true
    }

    /// Creates a scene configuration with the programmatic UIKit scene delegate.
    ///
    /// - Parameters:
    ///   - application: Application requesting a new scene.
    ///   - connectingSceneSession: Session that will own the UIKit window.
    ///   - options: Connection options supplied by UIKit.
    /// - Returns: Configuration using `SceneDelegate` and no storyboard.
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
