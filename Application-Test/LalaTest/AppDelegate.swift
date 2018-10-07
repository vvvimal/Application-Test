import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Google Maps SDK
        GMSServices.provideAPIKey(Global.api.googleMapsApiKey)
        
        // Color Theme
        UINavigationBar.appearance().barTintColor = .lalaOrange
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        // Remove NavigationBar Hairline
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        // Create a DeliveriesViewController and make it as an initial view controller.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: DeliveriesViewController())
        window?.makeKeyAndVisible()
        
        return true
    }
}

