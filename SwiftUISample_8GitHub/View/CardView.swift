//
//  CardView.swift
//  SwiftUISample_8GitHub
//
//  Created by 若江照仁 on 2021/05/13.
//

import SwiftUI

struct CardView: View {
    struct Input: Identifiable {
        let id = UUID()
        let iconImage: UIImage
        let title: String
        let language: String?
        let star: Int
        let description: String?
        let url: String
    }
    let input: Input

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(uiImage: input.iconImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
            Text(input.title)
                .foregroundColor(.black)
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text(input.language ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                    Text(input.star.description)
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            }
            Text(input.description ?? "")
                .lineLimit(nil)
        }
        .padding(24)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .frame(minWidth: 140, minHeight: 180)
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let description = "Declare the user interface and behavior for your app on every platform."
        CardView(input: CardView.Input(iconImage: UIImage(systemName: "cube")!,
                                       title: "SwiftUI",
                                       language: "Swift",
                                       star: 1000,
                                       description: description,
                                       url: "https:example.com")
        )
            .previewLayout(.sizeThatFits)
    }
}
