import UIKit

/// Owns the standalone UIKit example window for every application launch.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    /// Window retaining the example's navigation hierarchy.
    var window: UIWindow?

    /// Builds a fresh UIKit screen when the scene connects.
    ///
    /// - Parameters:
    ///   - scene: Scene being connected by UIKit.
    ///   - session: Session associated with the scene.
    ///   - connectionOptions: Options supplied for this connection.
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(
            rootViewController: UIKitHomeViewController()
        )
        window.makeKeyAndVisible()
        self.window = window
    }
}
