import Foundation

class AuthViewModel {
    
    // MARK: - Input Fields
    var grantType = "password"
    var authCode = ""
    
    // MARK: - Validation
    var isAuthValid: Bool {
        !grantType.isEmpty && !authCode.isEmpty
    }
    
    // MARK: - Callback Closures
    var onSuccess: ((SignupResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Auth API Call
    func getAuthCode() {
        guard isAuthValid else {
            onError?(AlertMessage.emptyAuthCode)
            return
        }
        
        let request = SignupRequest(AuthCode: authCode, grant_type: grantType)
        
        APIService.shared.postRequest(url: API.Auth.signup, body: request, responseType: SignupResponse.self) { result in
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
