//
//  HomeView.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/13.
//

import SwiftUI

struct HomeView: View {
    @State private var cardViewInputs: [CardView.Input] = []
    @State private var text = ""
    @StateObject private var viewModel: HomeViewModel = HomeViewModel(apiService: APIService())
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach(cardViewInputs) { input in
                    Button(action: {
                        
                    }) {
                        CardView(input: input)
                    }
                }
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: HStack {
                TextField("検索キーワードを入力", text: $text, onCommit: {
                    viewModel.apply(inputs: .onCommit(text: text))
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.asciiCapable)
                .frame(width: UIScreen.main.bounds.width - 40)
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
