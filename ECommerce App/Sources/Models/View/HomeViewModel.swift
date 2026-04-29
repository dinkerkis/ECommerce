import Foundation

class HomeViewModel {
    
    // MARK: - Callback Closures
    var onSuccess: ((CategoriesResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Fetch Categories API Call
    func fetchCategories() {
        APIService.shared.getRequest(url: API.Categories.categories, responseType: CategoriesResponse.self) { result in
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
