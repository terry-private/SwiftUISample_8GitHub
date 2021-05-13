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

struct SearchRepositoryRequest: APIRequestType {
    typealias Response = SearchRepositoryResponse
    var path: String { return "/search/repositories"}
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "q", value: query),
            .init(name: "order", value: "desc")
        ]
    }
    private let query: String
    init(query: String) {
        self.query = query
    }
}
