// Request Model
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// Response Model
struct LoginResponse: Codable {
    let success: Bool?
    let message: String?
    let data: User?
}

struct User: Codable {
    let user_id: String?
    let name: String?
    let email: String?
    let role: String?
    let token :String?
}
