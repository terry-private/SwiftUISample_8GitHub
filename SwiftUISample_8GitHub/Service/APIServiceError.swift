//
//  APIServiceError.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/13.
//

import Foundation

enum APIServiceError: Error {
    /// URLが不正な場合を表します。
    case invalidURL
    
    /// APIレスポンスにエラーが発生したことを表します。
    case responseError
    
    /// JSONのパース時にエラーが発生したことを表します。
    case parseError(Error)
}

