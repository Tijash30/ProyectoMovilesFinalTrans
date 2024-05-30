//
//  QRView.swift
//  finalMoviles
//
//  Created by Marcelo Preciado Fausto on 26/05/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRView: View {
    @StateObject var DB : DBManager = DBManager.shared
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var qrNumber : Int = 0
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        
        VStack{
            Button(action: {
                DB.availableQR = ""
                User.shared.loginCorrect = false
                self.presentationMode.wrappedValue.dismiss()

            }, label: {
                Text("Cerrar Sesión")
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding()
                  .frame(width: 150, height: 50)
                  .background(Color.red)
                  .cornerRadius(10)
                
            })
            .padding()
            .position(x: UIScreen.main.bounds.size.width - 80,y: 0)

            VStack{
                if DB.availableQR.isEmpty{
                    Button(action: {
                        DB.buscarYActualizarClaveLibre()
                    }, label: {
                        Text("Buscar QR")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    })
                }
               
                
                if !DB.availableQR.isEmpty{
                    Image(uiImage: generarImagenQR(llave: DB.availableQR))
                }
            }.position(x: UIScreen.main.bounds.size.width / 2)
          
        }
        .onChange(of: DB.availableQR){
            print(DB.availableQR)
        }

    }
    
    func generarImagenQR(llave: String) -> UIImage{
         
        filter.message = Data(llave.utf8)
        let transforma = CGAffineTransform(scaleX: 10, y: 10)
        
        if let imagenResultante = filter.outputImage?.transformed(by: transforma){
            if let cgimg = context.createCGImage(imagenResultante, from: imagenResultante.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    QRView()
}

