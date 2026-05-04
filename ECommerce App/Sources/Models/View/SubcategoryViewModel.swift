import Foundation

class SubcategoryViewModel {
    
    // MARK: - Callback Closures
    var onSuccess: ((SubcategoriesResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Fetch Categories API Call
    func fetchSubcategories(_ categoryId: String) {
        let request = SubcategoriesRequest(category: categoryId, page: 1, limit: 20)
        
        APIService.shared.getRequest(url: API.Categories.subcategories, query: request, responseType: SubcategoriesResponse.self) { result in
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
