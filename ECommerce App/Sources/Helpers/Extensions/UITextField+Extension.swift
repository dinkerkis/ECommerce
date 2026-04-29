import UIKit

@IBDesignable
extension UITextField {
    
    // MARK: - Padding
    @IBInspectable var leftPadding: CGFloat {
        get { return leftView?.frame.width ?? 0 }
        set {
            if newValue > 0 {
                let padding = UIView(frame: CGRect(x: 0, y: 0, width: adjustedForDevice(newValue), height: frame.height))
                leftView = padding
                leftViewMode = .always
            }
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
        get { return rightView?.frame.width ?? 0 }
        set {
            if newValue > 0 {
                let padding = UIView(frame: CGRect(x: 0, y: 0, width: adjustedForDevice(newValue), height: frame.height))
                rightView = padding
                rightViewMode = .always
            }
        }
    }
    
    // MARK: - Device Type–Aware Scaling
    private func adjustedForDevice(_ value: CGFloat) -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return value * 1.5
        default:
            return value
        }
    }
}
