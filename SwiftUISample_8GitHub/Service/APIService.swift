//
//  APIService.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/13.
//

import Foundation
import Combine

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

protocol APIServiceType {
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}

final class APIService: APIServiceType {
    private let baseURLString: String
    init(baseURLString: String = "https://api.github.com") {
        self.baseURLString = baseURLString
    }
    
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
        
        guard let pathURL = URL(string: request.path, relativeTo: URL(string: baseURLString)) else {
            return Fail(error: APIServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapでレスポンスデータのみ
            .map { data, urlResponse in data }
            // エラーが起きたらresponseErrorを返す
            .mapError { _ in APIServiceError.responseError }
            // JSONからデータオブジェクトにデコードする
            .decode(type: Request.Response.self, decoder: decoder)
            // デコードでエラーが起きたらparseErrorを返す
            .mapError({ (error) -> APIServiceError in
                APIServiceError.parseError(error)
            })
            // ストリームをメインスレッドに流れるように変換
            .receive(on: RunLoop.main)
            // Publisherの型を消去
            .eraseToAnyPublisher()
    }
}
