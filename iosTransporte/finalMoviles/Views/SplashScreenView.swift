//
//  SplashScreenView.swift
//  finalMoviles
//
//  Created by Marcelo Preciado Fausto on 26/05/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack{
            Image("travelLogo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 300)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
            
        }
    }
}

#Preview {
    SplashScreenView()
}
