import UIKit

struct AlertTitle {
    static let error = "Error"
    static let logout = "Logout"
}

struct AlertMessage {
    static let cameraNotAvailable = "Camera not available on this device"
    static let emptyAuthCode = "Please enter company name"
    static let emptyEmailPassword = "Please enter email and password"
    static let emptyItemCode = "Please enter item code"
    static let enterValidEmail = "Please enter a valid email"
    static let logout = "Do you really want to logout?"
}

struct AlertHelper {
    
    static func showAlert(on viewController: UIViewController, title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
                completion?()
            }
            alert.addAction(okAction)
            
            alert.view.tintColor = .black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true)
        }
    }
    
    static func showOKCancelAlertWithCompletion(on viewController: UIViewController, title: String, message: String, btnOkTitle: String = "Yes", btnCancelTitle: String = "No", btnCancelStyle: UIAlertAction.Style = .default, onOk: @escaping ()->(), onCancel: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            alert.addAction(UIAlertAction(title: btnCancelTitle, style: btnCancelStyle, handler: { (action:UIAlertAction) in
                onCancel()
            }))
            
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true)
        }
    }
}
