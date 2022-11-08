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
    @State private var editingEmailTextfield = false
    @State private var editingPasswordTextfield = false
    
    // MARK: View
    var body: some View {
        ZStack {
            Image("background-3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Sección superior
                    Text("Registrarse")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Ingresa al taller de SwiftUI Avanzado, 20 horas de desarrollo con funciones y diseño avanzado")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    
                    // MARK: - Inputs
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextfield)
//                        Image(systemName: "envelope.open.fill")
//                            .foregroundColor(.white)
                        
//                        TextField("Email", text: $email)
                        TextField("Email", text: $email) { isEditing in
                            editingEmailTextfield = isEditing
                            editingPasswordTextfield = false
                        }
                            .colorScheme(.dark)
                            .foregroundColor(Color.white.opacity(0.6))
                            // Propiedades del teclado
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                    } // HStack Email
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
                        TextfieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextfield)
//                        Image(systemName: "key.fill")
//                            .foregroundColor(.white)
                        
                        SecureField("Password", text: $email)
                            .colorScheme(.dark)
                            .foregroundColor(Color.white.opacity(0.6))
                            // Propiedades del teclado
                            .autocapitalization(.none)
                            .textContentType(.password)
                    } // HStack
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
                    .onTapGesture {
                        editingPasswordTextfield = true
                        editingEmailTextfield = false
                    }
                    
                    GradientButton()
                    
//                    Button {
//                        print("Registrarse")
//                    } label: {
//                        // Text("Registrarse")
//                        GeometryReader() { geometry in
//                            ZStack {
//                                AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center, angle: .degrees(0))
//                                    .blendMode(.overlay)
//                                    .blur(radius: 8.0)
//                                    .mask(
//                                        RoundedRectangle(cornerRadius: 16.0)
//                                            .frame(height: 50)
//                                            .frame(maxWidth: geometry.size.width - 16)
//                                            .blur(radius: 8.0)
//                                    )
//
//                                GradientText(text: "Registrarse")
//                                    .font(.headline)
//                                    .frame(width: geometry.size.width - 16)
//                                    .frame(height: 50)
//                                    .background(
//                                        Color("tertiaryBackground")
//                                            .opacity(0.8)
//                                    )
//                                    .overlay(
//                                    RoundedRectangle(cornerRadius: 16)
//                                        .stroke(Color.white, lineWidth: 1.8)
//                                        .blendMode(.normal)
//                                        .opacity(0.6)
//                                    )
//                                    .cornerRadius(16)
//                            }
//                        }
//                    } // Button Registrarse
                    
                    // MARK: - Sección bottom
                    Text("Al registrarse, acepta nuestros Términos y Condiciones y Política de Privacidad")
                        .font(.footnote)
                        .foregroundColor(Color.white.opacity(0.6))
                    // Divider()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            print("Pasar a Ingresar")
                        } label: {
                            HStack(spacing: 4) {
                                Text("¿Ya tiene cuenta?")
                                    .font(.footnote)
                                    .foregroundColor(Color.white.opacity(0.6))
                                
                                GradientText(text: "Ingresar")
                                    .font(.footnote)
                                    .bold()
                                
//                                Text("Ingresar")
//                                    .font(.footnote)
//                                    .bold()
//                                    .gradientForeground(colors:
//                                                            [Color("pink-gradient-1"),
//                                                             Color("pink-gradient-2")])
                            } // HStack
                        } // Button
                    } // VStack

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

