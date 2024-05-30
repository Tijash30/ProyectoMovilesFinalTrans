//
//  RecoverPassword.swift
//  finalMoviles
//
//  Created by Marcelo Preciado Fausto on 26/05/24.
//

import SwiftUI

struct RecoverPassword: View {
    @State var email : String = ""
    @State var update     : Bool = false
    @State var pregunta   : String = "¿Cómo se llamó tu primer mascota?"
    @State var respuesta  : String = ""
    @State var newPassword  : String = ""
    @State var showAlert : Bool = false
    @StateObject var DB : DBManager = DBManager.shared
    
    var body: some View {
        VStack{
            
            Form {
                Section(header: Text("Comprueba que eres tú")) {
                    TextField("Email", text: $email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    VStack{
                        Text("Pregunta de recuperación de cuenta").bold()
                        TextSelector(name: "", options: ["¿Cómo se llamó tu primer mascota?", "¿Cuál es tu película favorita?", "¿En qúe ciudad naciste?", "¿Cuál fue el nombre de tu escuela primaria?", "¿Cuál es el nombre de tu personaje de ficción favorito?"], update: $update, selection: $pregunta).padding(5)
                    }
                    
                    TextField("Respuesta", text: $respuesta)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    Button(action: {
                        recoverPassword()
                        
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.orange)
                            Text("Comprobar")
                                .foregroundColor(.white)
                                .bold()
                        }
                    })
                }
                if DB.comprobedUser{
                    Section(header: Text("Cambiar contraseña")) {
                        TextField("Nueva contraseña", text: $newPassword)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        Button(action: {
                            changePassword()
                            
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.green)
                                Text("Cambiar")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        })
                    }
                }
                
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(DB.alert.title!),
                message: Text(DB.alert.message!),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        .onChange(of: DB.showAlert){
            showAlert = true

        }
    }
    func recoverPassword(){
        DB.recoveryPassword(searchedEmail: email,searchedQuestion: pregunta, searchedAnswer: respuesta)
    }
    
    func changePassword(){
        print(email, newPassword)
        DB.changePassword(email: email, newPassword: newPassword)
    }
}

#Preview {
    RecoverPassword()
}
