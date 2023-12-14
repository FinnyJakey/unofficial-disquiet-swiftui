//
//  TrendingProductsView.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/02.
//

import SwiftUI

struct TrendingProductsView: View {
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var selection: Int = 0
    
    let trendingProducts: [TrendingProduct]
    let initiated: Bool
    
    @EnvironmentObject private var safariModel: SafariModel
    
    var body: some View {
        if initiated {
            Button {
                safariModel.link = "https://disquiet.io/product/\(trendingProducts[selection].urlSlug.encodeUrl()!)"
                safariModel.isTrendingProductScreenActive.toggle()
            } label: {
                HStack {
                    Text("\(selection + 1)")
                        .foregroundColor(Color(hex: 0xacacac))
                        .padding(.horizontal, 4)

                    AsyncImage(url: URL(string: trendingProducts[selection].thumbnail)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 48, height: 48)
                    }
                    
                    Spacer()

                    Text(trendingProducts[selection].name)
                        .lineLimit(1)
        
                    Spacer()
                    
                    Text(trendingProducts[selection].tagline)
                        .foregroundColor(Color(hex: 0xacacac))
                        .lineLimit(1)
        
                    if trendingProducts[selection].isNew {
                        Text("새로 나온")
                            .foregroundColor(Color(hex: 0xff5c02))
                    }
                }
                .font(.callout)
                .fontWeight(.medium)
                .padding(8)
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $safariModel.isTrendingProductScreenActive) {
                SafariScreen(url: safariModel.link)
            }            .frame(maxWidth: .infinity)
            .background(Color("ItemBackgroundColor"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .onReceive(timer) { _ in
                withAnimation {
                    selection = (selection + 1) % trendingProducts.count
                }
            }
        }
        
    }
}

//struct TrendingProductsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendingProductsView()
//    }
//}
