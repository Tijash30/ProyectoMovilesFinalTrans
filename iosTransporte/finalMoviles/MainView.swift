//
//  ContentView.swift
//  finalMoviles
//
//  Created by Marcelo Preciado Fausto on 23/05/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var user : User = User.shared
    @State       var showQRView : Bool      = false
    @State       var showRegisterView : Bool      = false
    @State       var showLoginView    : Bool      = false
    
    @State var showSplash : Bool = true


    var body: some View {
        if showSplash{
            SplashScreenView()
                .transition(.opacity)
                .animation(Animation.easeInOut(duration: 3.0), value: 200)
                .onAppear(){
                    DispatchQueue.main
                        .asyncAfter(deadline: .now() + 1)
                        {
                            withAnimation{
                                self.showSplash = false
                            }
                        }
                }

        }else{
            NavigationStack{
                VStack {
                    
                    HeaderView(title: "Boletos", subtitle: "QR", background: .green)
                        .offset(y: -100)

                    HStack{
                        Spacer()
                        
                        if user.loginCorrect{
                            Text(user.email)
                        }
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(user.loginCorrect ? .blue : .gray)
                    }.offset(y: -70)
                    .frame(height: 0)
                    
                 
                    Spacer()
                    Image("travelLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .offset(y: -50)
                
                    
                    VStack{
                        if user.errorMessage == "Inicia sesion"{
                            Text(user.errorMessage)
                                .foregroundColor(Color.red)
                        }
                        Button(action: {
                            if user.loginCorrect{
                                user.errorMessage = ""
                                showQRView = true
                            }else{
                                user.errorMessage = "Inicia sesion"
                            }
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.green)
                                Text("Boletos")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        })
                        
                        //------------
                        Button(action: {
                            showLoginView = true
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                Text("Login")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        })
                        
                        Button(action: {
                            showRegisterView = true
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.orange)
                                Text("Register")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        })

                    }
                    .frame(width: UIScreen.main.bounds.size.height/3, height: UIScreen.main.bounds.size.height/3)
                    Spacer()
                }
                .navigationDestination(isPresented: $showQRView){
                    QRView()
                }
               .navigationDestination(isPresented: $showLoginView){
                    LoginView()
                }
               .navigationDestination(isPresented: $showRegisterView){
                   RegisterView()
               }
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
       

    }
}

#Preview {
    MainView()
}
