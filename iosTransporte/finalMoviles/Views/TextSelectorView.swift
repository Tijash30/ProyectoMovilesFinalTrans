//
//  TextSelector.swift
//  Japi
//
//  Created by Marcelo Preciado Fausto on 08/05/24.
//

import SwiftUI
typealias action = ()

struct TextSelector: View {
    
    @State       var name       : String
    @State       var showKeyPad : Bool      = false
    var options : [String]
    @Binding var update : Bool
    @Binding var selection : String
    
    
    var body: some View {
        HStack{
            if !name.isEmpty{
                Text("\(name) : ").font(.system(size: 12)).frame(width: 200)
                Spacer()
            }
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self){option in
                    Button(action: {
                         
                        
                        update.toggle()
                    }, label: {
                        Text("\(option)")
                    })
                }
            }
            .frame(width: 300)
            .pickerStyle(.menu)
            .background(.ultraThinMaterial)
            .tint(.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 1)
            )
        }
    }
    
    func openAnimationOptions() -> some View {
        Picker(selection: $selection, label: Text("Select one option")) {            ForEach(options, id: \.self){option in
            Button(action: {
                
                update.toggle()
            }, label: {
                Text("\(option)").font(.system(size: 5))
            })
        }
        }
        
    }
    
}



#Preview {
    TextSelector(name: "Options", options: ["op1", "op2", "op3"],update: .constant(true), selection: .constant("yo"))
}
