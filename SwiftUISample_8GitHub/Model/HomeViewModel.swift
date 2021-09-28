//
//  HomeViewModel.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/20.
//

import Foundation
import Combine
import UIKit

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
    private let onCommitSubject = PassthroughSubject<String, Never>()
    // APIリクエストが完了したときにイベント発行するSubject
    private let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never>()
    // エラーが起きたらイベント発行するSubject
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    private var cancellables: [AnyCancellable] = []

    init(apiService: APIServiceType) {
        self.apiService = apiService
        bind() // Subjectをバインドする
    }

    func bind() {
        let responseSubscriber = onCommitSubject
            .flatMap { [apiService] (query) in
                apiService.request(with: SearchRepositoryRequest(query: query))
                    .catch { [weak self] error -> Empty<SearchRepositoryResponse, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .map{ $0.items }
            .sink(receiveValue: { [weak self] (repositories) in
                guard let self = self else { return }
                self.cardViewInputs = self.convertInput(repositories: repositories)
                self.inputText = ""
                self.isLoading = false
            })
        
        let loadingStartSubscriber = onCommitSubject.map{_ in true}.assign(to:\.isLoading,on:self)
    }

    func apply(inputs: Inputs) {
        switch inputs {
        case .onCommit(let inputText):
            onCommitSubject.send(inputText) // ここが実行
        case .tappedCardView(let urlString):
            repositoryUrl = urlString
            isShowSheet = true
        }
    }
    private func convertInput(repositories: [Repository]) -> [CardView.Input] {
        return repositories.compactMap { (repo) -> CardView.Input? in
            guard let url = URL(string: repo.owner.avatarUrl) else {
                return nil
            }
            let data = try? Data(contentsOf: url)
            let image = UIImage(data: data ?? Data()) ?? UIImage()
            return CardView.Input(iconImage: image,
                                  title: repo.name,
                                  language: repo.language,
                                  star: repo.stargazersCount,
                                  description: repo.description,
                                  url: repo.htmlUrl)
        }
    }
}
