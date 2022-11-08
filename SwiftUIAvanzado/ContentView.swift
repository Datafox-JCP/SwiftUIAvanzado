//
//  ContentView.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 07/11/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: Properties
    @State private var email = ""
    @State private var password = ""
    
    // MARK: View
    var body: some View {
        ZStack {
            Image("background-3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ingresar")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Ingresa al taller de SwiftUI Avanzado, 20 horas de desarrollo con funciones avanzadas y diseño moderno")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.open.fill")
                            .foregroundColor(.white)
                        
                        TextField("Email", text: $email)
                            .colorScheme(.dark)
                            .foregroundColor(Color.white.opacity(0.6))
                            // Propiedades del teclado
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                    } // HStack Email
                    .padding(.leading, 8)
                    .frame(height: 52)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1.0)
                            .blendMode(.overlay)
                    }
                    .background(
                    Color("secondaryBackground")
                        .cornerRadius(16)
                        .opacity(0.7)
                    )
                    
                    HStack(spacing: 12) {
                        Image(systemName: "key.fill")
                            .foregroundColor(.white)
                        
                        TextField("Email", text: $password)
                            .colorScheme(.dark)
                            .foregroundColor(Color.white.opacity(0.6))
                            // Propiedades del teclado
                            .autocapitalization(.none)
                            .textContentType(.password)
                    } // HStack Password
                    .padding(.leading, 8)
                    .frame(height: 52)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1.0)
                            .blendMode(.overlay)
                    }
                    .background(
                    Color("secondaryBackground")
                        .cornerRadius(16)
                        .opacity(0.7)
                    )
                } // VStack contenido
                .padding(20)
            } // VStack Card
            .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white.opacity(0.2))
                .background(Color("secondaryBackground").opacity(0.5))
                .background(VisualEffectBlur(blurStyle: .systemThinMaterial))
                .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
        } // ZStack
    }
}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
