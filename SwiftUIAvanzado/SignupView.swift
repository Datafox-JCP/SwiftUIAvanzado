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
import AuthenticationServices
import CryptoKit

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
    @State private var signInWithAppleObject = SigInWithAppleObject()
    @State private var fadeToggle = true
    
    @State private var showAlertView = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], animation: .default)
    private var savedAccounts: FetchedResults<Account>
    
    private let generator = UISelectionFeedbackGenerator()
    
        // MARK: View
    var body: some View {
        ZStack {
            Image(signupToggle ? "background-3" : "background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 1.0 : 0.0)
            
                // Para la transición del fondo
            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 0.0 : 1.0)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                        // MARK: - Sección superior
                    Text(signupToggle ? "Registrarse" : "Ingresar")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Ingresa al taller de SwiftUI Avanzado, 20 horas de desarrollo con funciones y diseño avanzado")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    
                        // MARK: - Input Email
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextfield, passedImage: .constant(nil))
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
                    
                        // MARK: - Input Password
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextfield, passedImage: .constant(nil))
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
                    
                        // MARK: - Button Crear cuenta
                    GradientButton(buttonTitle: signupToggle ? "Crear Cuenta" : "Ingresar") {
                        generator.selectionChanged()
                        signup()
                    }
                    // Pasar a Profile si ya ha ingresado
                    .onAppear() {
                        Auth.auth()
                            .addStateDidChangeListener { auth, user in
                                if let currentUser = user {
                                    if savedAccounts.count == 0 {
                                        // Añadir datos a Core Data
                                        let userDataToSave = Account(context: viewContext)
                                        userDataToSave.name = currentUser.displayName
                                        userDataToSave.bio = nil
                                        userDataToSave.userID = currentUser.uid
                                        userDataToSave.numberOfCertificates = 0
                                        userDataToSave.proMember = false
                                        userDataToSave.twitter = nil
                                        userDataToSave.website = nil
                                        userDataToSave.profileImage = nil
                                        userDataToSave.userSince = Date()
                                        
                                        do {
                                            try viewContext.save()
                                            DispatchQueue.main.async {
                                                showProfileView.toggle()
                                            }
                                        } catch let error {
                                            alertTitle = "No fue posible crear la cuenta"
                                            alertMessage = error.localizedDescription
                                            showAlertView.toggle()
                                        }
                                    } else {
                                        showProfileView.toggle()
                                    }
                                }
//                                if user != nil {
//                                    showProfileView.toggle()
//                                }
                            }
                    }
                    
                        // MARK: - Sección para el cambio de pantalla
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
                                sendPasswordResetEmail()
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
                            
                                // MARK: SigIn con Apple
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.white.opacity(0.2))
                            
                            Button(action: {
                                print("Sign in with Apple")
                                    // signInWithAppleObject.signInWithApple()
                            },  label: {
                                SignInWithAppleButton()
                                    .frame(height: 50)
                                    .cornerRadius(16)
                            })
                        } // Condición
                        
                            // MARK: - Button registrarse o ingresar
                        Button {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                fadeToggle.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        self.fadeToggle.toggle()
                                    }
                                }
                            }
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
                // Presenta Alert sobre el SignIn y Password
            .alert(isPresented: $showAlertView) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
            }
        } // ZStack
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
            // para leer los daos en ProfileView
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
    
        // MARK: - Functions
    func signup() {
        if signupToggle {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else {
                        /// Envía la Alert
                    alertTitle = "Opps!"
                    alertMessage = (error!.localizedDescription)
                    showAlertView.toggle()
                        //print(error!.localizedDescription)
                    return
                }
                print("Usuario registrado")
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                        /// Envía la Alert
                    alertTitle = "Opps!"
                    alertMessage = (error!.localizedDescription)
                    showAlertView.toggle()
                        //print(error!.localizedDescription)
                    return
                }
                print("Usuario registrado")
            }
        }
    }
    
    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                    /// Envía la Alert
                alertTitle = "Opps!"
                alertMessage = (error!.localizedDescription)
                showAlertView.toggle()
                    //print(error!.localizedDescription)
                return
            }
            alertTitle = "Se ha enviado correo para restaurar su contraseña"
            alertMessage = "Verifique su correo para encontrar instrucciones para restaurar su contraseña"
            showAlertView.toggle()
                // print("Correo para resetear password enviado")
        }
    }
}

    // MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

