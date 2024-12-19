import UIKit

// MARK: - SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    // MARK: - UISceneSession Lifecycle
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let newsVC = NewsViewController()
        let nav = UINavigationController(rootViewController: newsVC)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
