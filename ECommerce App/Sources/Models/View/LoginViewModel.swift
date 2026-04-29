import Foundation

class LoginViewModel {
    
    // MARK: - Input Fields
    var email = ""
    var password = ""
    
    // MARK: - Validation
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email.lowercased())
    }
    
    var isLoginValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Callback Closures
    var onSuccess: ((LoginResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Login API Call
    func loginUser() {
        guard isValidEmail else {
            onError?(AlertMessage.enterValidEmail)
            return
        }
        
        guard isLoginValid else {
            onError?(AlertMessage.emptyEmailPassword)
            return
        }
        
        let request = LoginRequest(email: email, password: password)
        
        APIService.shared.postRequest(url: API.Auth.login, body: request, responseType: LoginResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.onSuccess?(response)
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
