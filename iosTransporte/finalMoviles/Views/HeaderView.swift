//
//  HeaderView.swift
//  FinalComputo
//
//  Created by Marcelo Preciado Fausto on 19/05/24.
//

import SwiftUI

struct HeaderView: View {
    let title : String
    let subtitle : String
    let background : Color
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(background)
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                
            
            VStack{
                Text("\(title)")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .bold()
                Text("\(subtitle)")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }.offset(y: 50)
        }
        .frame(width: UIScreen.main.bounds.width,
               height: UIScreen.main.bounds.height/3)
    }
}

#Preview {
    HeaderView(title: "Title", subtitle: "Subtitle", background: .blue)
}
