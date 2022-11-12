//
//  ProfileView.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 08/11/22.
//

import SwiftUI
import FirebaseAuth
import CoreData

struct ProfileView: View {
    // MARK: Properties
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSettingsView = false
    
    @State private var showAlertView = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var updater = true
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID = %@", Auth.auth().currentUser!.uid), animation: .default)
    private var savedAccounts: FetchedResults<Account>
    
    @State private var currentAccount: Account?
    
    // MARK: View
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        // Foto de perfil
                        if currentAccount?.profileImage != nil {
                            GradiantProfilePictureView(profilePicture: UIImage(data: currentAccount!.profileImage!)!)
                                .frame(width: 66, height: 66)
                        } else {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("pink-gradient-1"))
                                    .frame(width: 66, height: 66, alignment: .center)
    
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25, weight: .medium, design: .rounded))
                            } // ZStack foto
                            .frame(width: 66, height: 66, alignment: .center)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(currentAccount?.name ?? "Sin nombre")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            
                            Text("Ver perfil")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        // MARK: - Button para settings
                        Button {
                            showSettingsView.toggle()
                        } label: {
                            TextfieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
                        }
                    } // HStack
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text(currentAccount?.bio ?? "No bio")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    if currentAccount?.numberOfCertificates != 0 {
                        Label("Tiene \(currentAccount?.numberOfCertificates ?? 0) certificados desde \(currentAccount?.userSince ?? Date())", systemImage: "calendar")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.footnote)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        if currentAccount?.twitter != nil {
                            Image("Twitter")
                                .resizable()
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                        
                        if currentAccount?.website != nil {
                            Image(systemName: "link")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            
                            Text(currentAccount?.website ?? "Sin website")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.footnote)
                        }
                    } // HStack botom
                } // VStack contenido
                .padding(16)
                
                // MARK: - Button compra
                GradientButton(buttonTitle: "Comprar curso") {
                    print("IAP")
                }
                .padding(.horizontal, 16)
                
                // MARK: - Button restaurar compras
                Button {
                    print("Restaurar compra")
                } label: {
                    GradientText(text: "Restaurar compras")
                        .font(.footnote.bold())
                }
                .padding(.bottom)
            } // VStack card
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor"), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal, 10)
            
            // MARK: - Cerrar sesión
            
            VStack {
                Spacer()
                
                Button {
                    signout()
                } label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        // Voltear el icono
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0.0, y: 0.0, z: 1.0))
                        .background(Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .frame(width: 42, height: 42, alignment: .center)
                            .overlay(
                                VisualEffectBlur(blurStyle: .dark)
                                    .cornerRadius(21)
                                    .frame(width: 42, height: 42, alignment: .center)
                            )
                        )
                }
            }
            .padding(.bottom, 64)
        } // ZStack background
        .colorScheme(updater ? .dark : .dark) // forzar redibujar pantalla
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
                .environment(\.managedObjectContext, self.viewContext)
            // para forzar redibujar pantalla
                .onDisappear() {
                    currentAccount = savedAccounts.first!
                    updater.toggle()
                }
        }
        .onAppear() {
            currentAccount = savedAccounts.first
            
            if currentAccount == nil {
                let userDataToSave = Account(context: viewContext)
                userDataToSave.name = Auth.auth().currentUser!.displayName
                userDataToSave.bio = nil
                userDataToSave.userID = Auth.auth().currentUser!.uid
                userDataToSave.numberOfCertificates = 0
                userDataToSave.proMember = false
                userDataToSave.twitter = nil
                userDataToSave.website = nil
                userDataToSave.profileImage = nil
                userDataToSave.userSince = Date()
                
                do {
                    try viewContext.save()
                } catch let error {
                    alertTitle = "No fue posible crear la cuenta"
                    alertMessage = error.localizedDescription
                    showAlertView.toggle()
                }
            }
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .cancel())
        }
    }
    
    // MARK: Functions
    func signout() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
