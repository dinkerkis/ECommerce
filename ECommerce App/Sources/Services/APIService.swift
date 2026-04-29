import UIKit
import Foundation

enum APIError: Error {
    case invalidURL
    case encodingFailed
    case noData
    case decodingFailed
    case serverError(statusCode: Int)
}

class APIService {
    static let shared = APIService()
    private init() {}

    // POST request that adapts headers based on token presence
    func postRequest<Request: Codable, Response: Codable>(url: String, body: Request, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void) {
        guard let endpoint = URL(string: url) else {
            return completion(.failure(APIError.invalidURL))
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authenticated request
        if let token = SessionManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        }
        catch {
            return completion(.failure(APIError.encodingFailed))
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

//            if let httpResponse = response as? HTTPURLResponse,
//               !(200...299).contains(httpResponse.statusCode) {
//                return completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
//            }

            guard let data = data else {
                return completion(.failure(APIError.noData))
            }

            print("Raw JSON:", String(data: data, encoding: .utf8) ?? "nil")
            
            do {
                let decoded = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(decoded))
            }
            catch {
                completion(.failure(APIError.decodingFailed))
            }
        }.resume()
    }
    
    // GET request
    func getRequest<Response: Codable>(url: String, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void) {
        guard let endpoint = URL(string: url) else {
            return completion(.failure(APIError.invalidURL))
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"

        // Authenticated request
        if let token = SessionManager.shared.token {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

//            if let httpResponse = response as? HTTPURLResponse,
//               !(200...299).contains(httpResponse.statusCode) {
//                return completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
//            }

            guard let data = data else {
                return completion(.failure(APIError.noData))
            }

            print("Raw JSON:", String(data: data, encoding: .utf8) ?? "nil")
            
            do {
                let decoded = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(decoded))
            }
            catch {
                completion(.failure(APIError.decodingFailed))
            }
        }.resume()
    }

//    func uploadImage(image: UIImage, url: String, parameters: [String: String] = [:], completion: @escaping (Result<UploadImageResponse, Error>) -> Void) {
//        guard let url = URL(string: url),
//              let imageData = image.jpegData(compressionQuality: 0.8) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        if let token = SessionManager.shared.authToken {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//
//        var body = Data()
//
//        // Add text fields
//        for (key, value) in parameters {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.append("\(value)\r\n")
//        }
//
//        // Image
//        body.append("--\(boundary)\r\n")
//        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"upload.jpg\"\r\n")
//        body.append("Content-Type: image/jpeg\r\n\r\n")
//        body.append(imageData)
//        body.append("\r\n")
//
//        body.append("--\(boundary)--\r\n")
//
//        request.httpBody = body
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                return completion(.failure(error))
//            }
//
//            if let httpResponse = response as? HTTPURLResponse,
//               !(200...299).contains(httpResponse.statusCode) {
//                return completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
//            }
//
//            guard let data = data else {
//                return completion(.failure(APIError.noData))
//            }
//
//            print("Raw JSON:", String(data: data, encoding: .utf8) ?? "nil")
//            
//            do {
//                let decoded = try JSONDecoder().decode(UploadImageResponse.self, from: data)
//                completion(.success(decoded))
//            }
//            catch {
//                completion(.failure(APIError.decodingFailed))
//            }
//        }.resume()
//    }

    // MARK: - Form Encoding Utility
    private func convertToURLEncodedForm<T: Codable>(_ body: T) -> Data? {
        let mirror = Mirror(reflecting: body)
        let keyValuePairs = mirror.children.compactMap { (label, value) -> String? in
            guard let label = label else { return nil }
            return "\(label)=\(String(describing: value))"
        }
        let queryString = keyValuePairs.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return queryString.data(using: .utf8)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
