struct ViewControllerIdentifiers {
    
    static let LoginViewController = "LoginViewController"
    static let SubCategoriesViewController = "SubCategoriesViewController"
    static let TabBarController = "TabBarController"
}

import UIKit

enum ViewControllerType {
    case LoginViewController
    case SubCategoriesViewController
    case TabBarController
}

class ViewControllerHelper: NSObject {
    
    // This is used to retirve view controller and intents to reutilize the common code.
    
    class func getViewController(ofType viewControllerType: ViewControllerType) -> UIViewController {
        var viewController: UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if viewControllerType == .LoginViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginViewController) as! LoginViewController
        }
        else if viewControllerType == .SubCategoriesViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SubCategoriesViewController) as! SubCategoriesViewController
        }
        else if viewControllerType == .TabBarController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.TabBarController) as! TabBarController
        }
        else {
            print("Unknown view controller type")
        }
        
        if let vc = viewController {
            return vc
        }
        else {
            return UIViewController()
        }
    }
}
