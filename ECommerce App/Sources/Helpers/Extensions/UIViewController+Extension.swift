import UIKit

extension UIViewController {

    private static var loaderViewTag: Int { return 999999 }

    func showLoader() {
        // Prevent multiple loaders
        if view.viewWithTag(Self.loaderViewTag) != nil { return }

        let loaderBackground = UIView(frame: view.bounds)
        loaderBackground.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        loaderBackground.tag = Self.loaderViewTag
        loaderBackground.isUserInteractionEnabled = true // blocks all interactions

        // Add spinner
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = loaderBackground.center
        spinner.color = .black
        spinner.startAnimating()

        loaderBackground.addSubview(spinner)
        view.addSubview(loaderBackground)
    }

    func hideLoader() {
        if let loader = view.viewWithTag(Self.loaderViewTag) {
            loader.removeFromSuperview()
        }
    }
}

extension Encodable {
    var queryItems: [URLQueryItem]? {
        guard
            let data = try? JSONEncoder().encode(self),
            let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }

        return dict.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
    }
}
