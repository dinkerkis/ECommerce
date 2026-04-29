// Response Model
struct CategoriesResponse: Codable {
    let success: Bool?
    let message: String?
    let data: [Categories]?
}

struct Categories: Codable {
    let name: String?
    let description: String?
    let category_image: String?
    let category_id: String?
}
