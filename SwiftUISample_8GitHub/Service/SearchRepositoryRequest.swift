//
//  SearchRepositoryRequest.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/13.
//

import Foundation

struct SearchRepositoryRequest: APIRequestType {
    typealias Response = SearchRepositoryResponse
    var path: String { "/search/repositories" }
    var queryItems: [URLQueryItem]? {
        [
            .init(name: "q", value: query),
            .init(name: "order", value: "desc")
        ]
    }
    private let query: String
    init(query: String) {
        self.query = query
    }
}
