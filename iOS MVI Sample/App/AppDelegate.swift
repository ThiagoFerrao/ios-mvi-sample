import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNetwork()

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: GenString.AppDelegate.UISceneConfiguration.default,
            sessionRole: connectingSceneSession.role
        )
    }

    private func setupNetwork() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCredentialStorage = nil
        Network.shared.configuration = configuration
        Network.shared.interceptor = NetworkInterceptor()
    }
}
