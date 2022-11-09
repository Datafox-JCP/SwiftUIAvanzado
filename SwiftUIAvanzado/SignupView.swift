    //
    //  SignupView.swift
    //  SwiftUIAvanzado
    //
    //  Created by Juan Hernandez Pazos on 07/11/22.
    //

import SwiftUI
import CoreData
import AudioToolbox
import FirebaseAuth

struct SignupView: View {
        // MARK: Properties
    @State private var email = ""
    @State private var password = ""
    @State private var editingEmailTextfield = false
    @State private var editingPasswordTextfield = false
    @State private var emailIconBounce = false
    @State private var passwordIconBounce = false
    @State private var showProfileView = false
    @State private var signupToggle = true
    @State private var rotationAngle = 0.0
    
    private let generator = UISelectionFeedbackGenerator()
    
        // MARK: View
    var body: some View {
        ZStack {
            Image(signupToggle ? "background-3" : "background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                        // MARK: - Sección superior
                    Text(signupToggle ? "Registrarse" : "Ingresar")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Ingresa al taller de SwiftUI Avanzado, 20 horas de desarrollo con funciones y diseño avanzado")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    
                        // MARK: - Inputs
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextfield)
                            /// Permite ejecutar la animación
                            .scaleEffect(emailIconBounce ? 1.2 : 1.0)
                        
                        TextField("Email", text: $email) { isEditing in
                            editingEmailTextfield = isEditing
                            editingPasswordTextfield = false
                            generator.selectionChanged()
                                /// Animación de bounce en el icono
                            if isEditing {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    emailIconBounce.toggle()
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    emailIconBounce.toggle()
                                }
                            }
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
                            .scaleEffect(passwordIconBounce ? 1.2 : 1.0)
                        
                        SecureField("Password", text: $password)
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
                        /// La detección y efectos se hacen aquí pues Secure no acepta closure
                    .onTapGesture {
                        editingPasswordTextfield = true
                        editingEmailTextfield = false
                        generator.selectionChanged()
                        if editingPasswordTextfield {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                passwordIconBounce.toggle()
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                passwordIconBounce.toggle()
                            }
                        }
                    }
                    
                    GradientButton(buttonTitle: signupToggle ? "Crear Cuenta" : "Ingresar") {
                        generator.selectionChanged()
                        signup()
                    }
                    .onAppear() {
                        Auth.auth()
                            .addStateDidChangeListener { auth, user in
                                if user != nil {
                                    showProfileView.toggle()
                                }
                            }
                    }
                    
                        // MARK: - Sección bottom
                    if signupToggle {
                        Text("Al registrarse, acepta nuestros Términos y Condiciones y Política de Privacidad")
                            .font(.footnote)
                            .foregroundColor(Color.white.opacity(0.6))
                            // Divider()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.2))
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        if !signupToggle {
                            Button {
                                print(" Enviar correo para restaurar contraseña")
                            } label: {
                                HStack(spacing: 4) {
                                    Text("¿Olvidó su contraseña?")
                                        .font(.footnote)
                                        .foregroundColor(Color.white.opacity(0.6))
                                    
                                    GradientText(text: "Resetear contraseña")
                                        .font(.footnote)
                                        .bold()
                                } // HStack
                            } // Button
                        } // Condición
                        
                        Button {
                            withAnimation(.easeOut(duration: 0.7)) {
                                signupToggle.toggle()
                                /// Cambiar el ángulo
                                self.rotationAngle += 180
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(signupToggle ? "¿Ya tiene cuenta?" : "Obtenga su cuenta")
                                    .font(.footnote)
                                    .foregroundColor(Color.white.opacity(0.6))
                                
                                GradientText(text: signupToggle ? "Ingresar" : "Registrarse")
                                    .font(.footnote)
                                    .bold()
                            } // HStack
                        } // Button
                    } // VStack
                    
                } // VStack contenido
                .padding(20)
            } // VStack Card
            .rotation3DEffect(
                Angle(degrees: self.rotationAngle),
                axis:(x: 0.0, y:1.0, z: 0.0)
            )
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .systemThinMaterial))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            .rotation3DEffect(
                Angle(degrees: self.rotationAngle),
                axis:(x: 0.0, y:1.0, z: 0.0)
            )
        } // ZStack
          //        .fullScreenCover(isPresented: $showProfileView) {
          //            ProfileView()
          //        }
    }
    
        // MARK: - Functions
    func signup() {
        if signupToggle {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("Usuario registrado")
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                print("Usuario registrado")
            }
        }
    }
}

    // MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

