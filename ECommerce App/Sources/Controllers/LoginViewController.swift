import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets (View)
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // MARK: - ViewModel
    private var viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SessionManager.shared.isLoggedIn {
            if let vc = ViewControllerHelper.getViewController(ofType: .TabBarController) as? TabBarController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    // MARK: - Bind ViewModel Callbacks
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] response in
            self?.hideLoader()
            SessionManager.shared.saveLoginResponse(response)
            print(response)
            if let vc = ViewControllerHelper.getViewController(ofType: .TabBarController) as? TabBarController {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.hideLoader()
            AlertHelper.showAlert(on: self ?? UIViewController(), title: AlertTitle.error, message: errorMessage)
        }
    }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: - User Actions
    @IBAction func loginClicked(_ sender: UIButton) {
        showLoader()
        viewModel.email = txtEmail.text ?? ""
        viewModel.password = txtPassword.text ?? ""
        viewModel.loginUser()
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        
    }
}
