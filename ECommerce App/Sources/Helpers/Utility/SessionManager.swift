import Foundation

final class SessionManager {
    static let shared = SessionManager()

    private let userDefaults = UserDefaults.standard
    private let authTokenKey = "AuthToken"
    private let loginKey = "LoginResponse"
    private let signupKey = "SignupResponse"

    private init() {}

    // MARK: - Save
    func saveAuthResponse(_ response: SignupResponse) {
        do {
            let data = try JSONEncoder().encode(response)
            userDefaults.set(data, forKey: signupKey)
            userDefaults.set(response.data?.token ?? "", forKey: authTokenKey)
        } catch {
            print("Failed to save Auth Response:", error)
        }
    }
    
    func saveLoginResponse(_ response: LoginResponse) {
        do {
            let data = try JSONEncoder().encode(response)
            userDefaults.set(data, forKey: loginKey)
            userDefaults.set(response.data?.token ?? "", forKey: authTokenKey)
        } catch {
            print("Failed to save Login Response:", error)
        }
    }
    
    func saveToken(_ token: String) {
        userDefaults.set(token, forKey: authTokenKey)
    }

    // MARK: - Get
    func getAuthResponse() -> SignupResponse? {
        guard let data = userDefaults.data(forKey: signupKey) else { return nil }
        return try? JSONDecoder().decode(SignupResponse.self, from: data)
    }
    
    func getLoginResponse() -> LoginResponse? {
        guard let data = userDefaults.data(forKey: loginKey) else { return nil }
        return try? JSONDecoder().decode(LoginResponse.self, from: data)
    }

    // MARK: - Remove
    func clearResponse() {
        userDefaults.removeObject(forKey: authTokenKey)
        userDefaults.removeObject(forKey: loginKey)
        userDefaults.removeObject(forKey: signupKey)
    }

    // MARK: - Token Convenience
    var token: String? {
        return userDefaults.string(forKey: authTokenKey)
    }

    var isLoggedIn: Bool {
        guard let token = token, !token.isEmpty else {
            return false
        }
        return true
    }
}
