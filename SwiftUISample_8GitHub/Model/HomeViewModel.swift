//
//  HomeViewModel.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/20.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    enum Inputs {
        case onCommit(text: String)
        case tappedCardView(urlString: String)
    }
    
    // MARK: - Outputs
    // 表示するリポジトリーデータ
    @Published private(set) var cardViewInputs: [CardView.Input] = []
    // TextFieldで入力されたテキスト
    @Published var inputText: String = ""
    // エラーアラートを訪寺するかどうか
    @Published var isShowError = false
    // 読み込みテキストを表示するかどうか
    @Published var isLoading = false
    // シートを表示するかどうか
    @Published var isShowSheet = false
    // 表示するリポジトリーのURL
    @Published var repositoryUrl: String = ""
    
    // MARK: - Private
    private let apiService: APIServiceType
    // ユーザーの入力操作が終わった時にイベント発行するSubject
    private let onCommitSubject = PassthroughSubject<APIServiceError, Never>()
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        bind() // Subjectをバインドする
    }
}
