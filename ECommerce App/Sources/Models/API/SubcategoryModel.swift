// Request Model
struct SubcategoriesRequest: Codable {
    let category: String
    let page: Int
    let limit: Int
}

// Response Model
struct SubcategoriesResponse: Codable {
    let success: Bool?
    let message: String?
    let data: [Subcategories]?
    let pagination: Pagination?
}

struct Subcategories: Codable {
    let category_id: String?
    let description: String?
    let name: String?
    let sub_category_id: String?
    let sub_category_image: String?
}
