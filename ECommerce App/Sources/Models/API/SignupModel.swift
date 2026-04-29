// Request Model
struct SignupRequest: Codable {
    let AuthCode: String
    let grant_type: String
}

// Response Model
struct SignupResponse: Codable {
    let success: Bool?
    let message: String?
    let data: User?
}
