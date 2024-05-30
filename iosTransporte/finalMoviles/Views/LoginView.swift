//
//  LoginView.swift
//  finalMoviles
//
//  Created by Marcelo Preciado Fausto on 23/05/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var user : User = User.shared
    @State var email : String = ""
    @State var password : String = ""
    @StateObject var DB : DBManager = DBManager.shared
    @State var showAlert : Bool = false
    @State var recuperarContra : Bool = false
    
    
    var body: some View {
            
            VStack{
                HeaderView(title: "Login", subtitle: "", background: .green)
                    .offset(y: -100)
                
                Form{

                    
                    TextField("Email", text: $email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    Button(action: {
                        login(email: email, password: password)
                        
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.green)
                            Text("Login")
                                .foregroundColor(.white)
                                .bold()
                        }
                    })
                    HStack{
                        Spacer()
                        Button("¿Olvidaste tu contraseña?"){
                            recuperarContra = true
                        }
                        Spacer()
                    }
                    
                    
                }
                .offset(y: -50)
                Spacer()
            }
            .popover(isPresented: $recuperarContra) {
                RecoverPassword()
            }
        .onAppear(){
            user.errorMessage = ""
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(DB.alert.title!),
                message: Text(DB.alert.message!),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        .onChange(of: DB.alert){
            showAlert = true
        }
    }
    func login(email: String, password: String){
        DB.login(email: email, password: password)
    }
}

#Preview {
    LoginView()
}
