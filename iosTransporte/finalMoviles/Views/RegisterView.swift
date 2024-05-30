//
//  Register View.swift
//  FinalComputo
//
//  Created by Marcelo Preciado Fausto on 19/05/24.
//
import SwiftUI

struct RegisterView: View {
    
    @State var nombre     : String = ""
    @State var apellido   : String = ""
    @State var carrera    : String = ""
    @State var semestre   : String = ""
    @State var email      : String = ""
    @State var password   : String = ""
    
    @StateObject var user : User = User.shared
    @StateObject var DB   : DBManager = DBManager.shared
    @State var showAlert  : Bool = false
    @State var update     : Bool = false
    @State var pregunta   : String = "¿Cómo se llamó tu primer mascota?"
    @State var respuesta  : String = ""
    
    var body: some View {
        VStack{
            HeaderView(title: "Register", subtitle: "", background: .orange)
                .offset(y:-80)
            
            Form{
                
                TextField("Nombre", text: $nombre)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextField("Apellido", text: $apellido)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextField("Carrera", text: $carrera)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextField("Semestre", text: $semestre)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                
                VStack{
                    Text("Pregunta de recuperación de cuenta").bold()
                    TextSelector(name: "", options: ["¿Cómo se llamó tu primer mascota?", "¿Cuál es tu película favorita?", "¿En qúe ciudad naciste?", "¿Cuál fue el nombre de tu escuela primaria?", "¿Cuál es el nombre de tu personaje de ficción favorito?"], update: $update, selection: $pregunta).padding(5)
                    TextField("Respuesta", text: $respuesta)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                }
                
                Button(action: {
                    register()
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.orange)
                        Text("Create account")
                            .foregroundColor(.white)
                            .bold()
                    }
                })

            }.offset(y:-50)
          
        }.onAppear(){
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
    func register(){
        DB.register(nombre: nombre, apellido: apellido, carrera: carrera, semestre: semestre, email: email, password: password, pregunta: pregunta, respuesta: respuesta)
    }

}

#Preview {
    RegisterView()
}
