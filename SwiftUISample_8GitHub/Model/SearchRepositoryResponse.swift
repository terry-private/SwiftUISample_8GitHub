//
//  SearchRepositoryResponse.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/13.
//

import Foundation

struct SearchRepositoryResponse: Decodable {
    let items: [Repository]
}
