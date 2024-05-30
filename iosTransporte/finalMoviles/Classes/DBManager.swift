//
//  DBManager.swift
//  finalMoviles
//
//  Created by Marcelo Preciado Fausto on 23/05/24.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase


class DBManager: ObservableObject{
    let ref = Database.database().reference()
    @Published var showAlert : Bool = false
    @Published var alert : UIAlertController = UIAlertController()
    @Published var availableQR : String = ""
    @Published var comprobedUser : Bool = false
    
    static var shared : DBManager = DBManager()
    
    
    
    
    func register(nombre: String, apellido: String, carrera: String, semestre: String,email: String, password: String, pregunta: String, respuesta: String){
        Auth.auth().createUser(withEmail: email, password: password){Result, Error in
            if let resultado = Result, Error == nil{
                
                self.ref.child("usuarios").child(Auth.auth().currentUser!.uid).setValue(["nombre" : nombre, "apellido": apellido, "carrera": carrera, "semestre": semestre,"email": email, "password": password]){Error, DatabaseReference in
                    if Error == nil{
                        self.alert = UIAlertController(title: "Agregar usuario", message: "Se agrego usuario", preferredStyle: .alert)
                        self.alert.addAction(UIAlertAction(
                            title: "Aceptar",
                            style: .default
                        ))
                        self.showAlert.toggle()
                        self.saveRecoveryQuestion(email: email, pregunta: pregunta, respuesta: respuesta)
                    }else{
                        self.alert = UIAlertController(title: "Agregar usuario", message: "Error al cargar datos despues de usuario y password", preferredStyle: .alert)
                        self.alert.addAction(UIAlertAction(
                            title: "Aceptar",
                            style: .default
                        ))
                        self.showAlert.toggle()
                    }
                    
                }
                
            }else{
                self.alert = UIAlertController(title: "Agregar usuario", message: "Error al cargar usuario", preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(
                    title: "Aceptar",
                    style: .default
                ))
                self.showAlert.toggle()
                
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password){Result, Error in
            if let resultado = Result, Error == nil{
                
                self.alert = UIAlertController(title: "Login", message: "Login correcto", preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(
                    title: "Aceptar",
                    style: .default
                ))
                self.showAlert.toggle()
                User.shared.loginCorrect = true
                User.shared.email = email
            }else{
                self.alert = UIAlertController(title: "Login", message: "Login incorrecto" + (Error?.localizedDescription.description)!, preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(
                    title: "Aceptar",
                    style: .default
                ))
                self.showAlert.toggle()
            }
        }
    }
    
    func buscarYActualizarClaveLibre() {
        let ref = Database.database().reference().child("clave")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let claves = snapshot.children.allObjects as? [DataSnapshot] {
                for clave in claves {
                    if let claveData = clave.value as? [String: AnyObject],
                       let estatus = claveData["estatus"] as? String,
                       let correo = claveData["usuario"] as? String,
                       estatus == "libre", correo == User.shared.email {
                        
                        let claveRef = ref.child(clave.key)
                        claveRef.updateChildValues(["estatus": "ocupado"]) { error, _ in
                            if let error = error {
                                print("Error al actualizar estatus: \(error.localizedDescription)")
                            } else {
                                self.availableQR = clave.key
                                print("Clave \(clave.key) actualizada a 'ocupado'")
                            }
                        }
                        return
                    }
                }
            }
        }) { error in
            print("Error al buscar claves libres: \(error.localizedDescription)")
        }
    }
    
    func recoveryPassword(searchedEmail: String, searchedQuestion: String, searchedAnswer: String){
        let ref = Database.database().reference().child("recuperacion")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let cuentas = snapshot.children.allObjects as? [DataSnapshot] {
                for cuenta in cuentas {
                    if let cuentaData = cuenta.value as? [String: AnyObject],
                       let email = cuentaData["email"] as? String,
                       let answer = cuentaData["respuesta"] as? String,
                       let question = cuentaData["pregunta"] as? String,
                       email == searchedEmail && answer == searchedAnswer, question == searchedQuestion{
                        self.comprobedUser = true
                        return
                    }else{
                        self.comprobedUser = false
                    }
                }
            }
        }) { error in
            print("Error al buscar claves libres: \(error.localizedDescription)")
        }
    }
    
    func saveRecoveryQuestion(email: String, pregunta: String, respuesta: String){
        let ref = Database.database().reference().child("recuperacion").child(UUID().uuidString)
        
        let nuevaPregunta: [String: Any] = [
            "email": email,
            "pregunta": pregunta,
            "respuesta": respuesta
        ]
        
        ref.setValue(nuevaPregunta) { error, _ in
            if let error = error {
                self.alert = UIAlertController(title: "Pregunta", message: "Error al agregar pregunta" + (error.localizedDescription.description), preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(
                    title: "Aceptar",
                    style: .default
                ))
                self.showAlert.toggle()
            } else {
                print("Pregunta agregada exitosamente")
            }
        }
    }
    
    
    func agregarClave(numero: Int, estatus: String, usuario: String) {
        let ref = Database.database().reference().child("clave").child("\(numero)")
        
        let nuevaClave: [String: Any] = [
            "estatus": estatus,
            "numero": numero,
            "usuario": usuario
        ]
        
        ref.setValue(nuevaClave) { error, _ in
            if let error = error {
                self.alert = UIAlertController(title: "QR", message: "Error al agregar qr" + (error.localizedDescription.description), preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(
                    title: "Aceptar",
                    style: .default
                ))
                self.showAlert.toggle()
            } else {
                print("Clave agregada exitosamente")
            }
        }
    }
    
    func changePassword(email: String, newPassword: String) {
            let ref = Database.database().reference()
            
            ref.child("Usuarios").observeSingleEvent(of: .value, with: { snapshot in
                if let usuarios = snapshot.value as? [String: [String: Any]] {
                    for (userID, userInfo) in usuarios {
                        if let correo = userInfo["Correo"] as? String, correo == email {
                            // Actualizar la contraseña en la autenticación de Firebase
                            Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                                if let error = error {
                                    self.alert = UIAlertController(title: "Error", message: "Error al actualizar la contraseña: \(error.localizedDescription)", preferredStyle: .alert)
                                    self.alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                    self.showAlert.toggle()
                                    return
                                }
                                
                                // Actualizar la contraseña en la base de datos
                                ref.child("Usuarios").child(userID).updateChildValues(["Contraseña": newPassword]) { error, _ in
                                    if let error = error {
                                        self.alert = UIAlertController(title: "Error", message: "Error al actualizar la contraseña en la base de datos: \(error.localizedDescription)", preferredStyle: .alert)
                                        self.alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                        self.showAlert.toggle()
                                    } else {
                                        self.alert = UIAlertController(title: "Reautenticación", message: "Contraseña cambiada con éxito", preferredStyle: .alert)
                                        self.alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                        self.showAlert.toggle()
                                    }
                                }
                            }
                            return
                        }
                    }
                    self.alert = UIAlertController(title: "Error", message: "Correo no encontrado", preferredStyle: .alert)
                    self.alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.showAlert.toggle()
                } else {
                    self.alert = UIAlertController(title: "Error", message: "No se pudieron obtener los usuarios", preferredStyle: .alert)
                    self.alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.showAlert.toggle()
                }
            }) { error in
                self.alert = UIAlertController(title: "Error", message: "Error al obtener usuarios: \(error.localizedDescription)", preferredStyle: .alert)
                self.alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.showAlert.toggle()
            }
        }
    
}
