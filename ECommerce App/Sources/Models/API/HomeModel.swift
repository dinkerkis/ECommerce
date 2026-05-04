// Request Model
struct CategoriesRequest: Codable {
    let page: Int
    let limit: Int
}

// Response Model
struct CategoriesResponse: Codable {
    let success: Bool?
    let message: String?
    let data: [Categories]?
    let pagination: Pagination?
}

struct Categories: Codable {
    let name: String?
    let description: String?
    let category_image: String?
    let category_id: String?
}

struct Pagination: Codable {
    let hasNextPage: Bool?
    let hasPrevPage: Bool?
    let limit: Int?
    let page: Int?
    let total: Int?
    let totalPages: Int?
}
