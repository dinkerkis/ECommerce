struct API {
    static let baseURL = "http://103.164.67.226:8000"

    struct Auth {
        static let login = "\(baseURL)/api/login"
        static let signup = "\(baseURL)/api/signup"
    }
    
    struct Categories {
        static let categories = "\(baseURL)/api/categories"
        static let subcategories = "\(baseURL)/api/sub-categories"
    }
}
