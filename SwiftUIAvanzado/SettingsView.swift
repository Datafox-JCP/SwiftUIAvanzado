    //
    //  SettingsView.swift
    //  SwiftUIAvanzado
    //
    //  Created by Juan Hernandez Pazos on 11/11/22.
    //

import SwiftUI
import FirebaseAuth
import CoreData

struct SettingsView: View {
        // MARK: Properties
    @Environment(\.dismiss) private var dismiss
    
    @State private var editingNameTextfield = false
    @State private var editingTwitterTextfield = false
    @State private var editingSiteTextfield = false
    @State private var editingBioTextfield = false
    
    @State private var nameIconBounce = false
    @State private var twitterIconBounce = false
    @State private var siteIconBounce = false
    @State private var bioIconBounce = false
    
    @State private var name = ""
    @State private var twitter = ""
    @State private var site = ""
    @State private var bio = ""
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var showAlertView = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private let generator = UISelectionFeedbackGenerator()
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID = %@", Auth.auth().currentUser!.uid), animation: .default)
    private var savedAccounts: FetchedResults<Account>
    
    @State private var currentAccount: Account?
    
        // MARK: View
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Administre su perfil y cuenta")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.callout)
                
                    // Seleccionar foto
                Button {
                    print ("Mostrar galería")
                    self.showImagePicker = true
                } label: {
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false), passedImage: $inputImage)
                        
                        GradientText(text: "Seleccione foto")
                        
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .background(
                        Color.init(red: 26/255, green: 20/255, blue: 51/255)
                            .cornerRadius(16)
                    )
                } // Button
                
                    // Nombre
                GradiantTextField(editingTextfield: $editingNameTextfield, textfieldString: $name, iconBounce: $nameIconBounce, textfieldPlaceholder: "Nombre", textfieldIconString: "textformat.alt")
                    .autocapitalization(.words)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                
                    // Twitter
                GradiantTextField(editingTextfield: $editingTwitterTextfield, textfieldString: $twitter, iconBounce: $twitterIconBounce, textfieldPlaceholder: "Twitter", textfieldIconString: "at")
                    .autocapitalization(.none)
                    .keyboardType(.twitter)
                    .autocorrectionDisabled()
                
                    // Site
                GradiantTextField(editingTextfield: $editingSiteTextfield, textfieldString: $site, iconBounce: $siteIconBounce, textfieldPlaceholder: "Web", textfieldIconString: "link")
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                    .autocorrectionDisabled()
                
                    // Bio
                GradiantTextField(editingTextfield: $editingBioTextfield, textfieldString: $bio, iconBounce: $bioIconBounce, textfieldPlaceholder: "Bio", textfieldIconString: "text.justifyleft")
                    .autocapitalization(.sentences)
                    .keyboardType(.default)
                
                    // Button Guardar
                GradientButton(buttonTitle: "Guardar cambios") {
                        // Guardar cambios en CoreData
                    generator.selectionChanged()
                    
                    currentAccount?.name = self.name
                    currentAccount?.bio = self.bio
                    currentAccount?.twitter = self.twitter
                    currentAccount?.website = self.site
                    currentAccount?.profileImage = self.inputImage?.pngData()
                    
                    do {
                        try viewContext.save()
                        // Presentar alerta
                        alertTitle = "Cambios guardados"
                        alertMessage = "Se han guardado los cambios"
                        showAlertView.toggle()
                    } catch let error {
                        // Presentar error
                        alertTitle = "Ha ocurrido un error"
                        alertMessage = error.localizedDescription
                        showAlertView.toggle()
                    }
                }
                
                Spacer()
                
            } // VStack
            .padding()
            
            Spacer()
        } // HStack
        .background(Color("settingsBackground"))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$inputImage)
        }
        .onAppear() {
            currentAccount = savedAccounts.first!
            self.name = currentAccount?.name ?? ""
            self.bio = currentAccount?.bio ?? ""
            self.twitter = currentAccount?.twitter ?? ""
            self.site = currentAccount?.website ?? ""
            self.inputImage = UIImage(data: currentAccount?.profileImage ?? Data())
            self.name = currentAccount?.name ?? ""
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle),
                  message: Text(alertMessage),
                  dismissButton: .cancel())
        }
    }
    
    // MARK: Functions
    
}

    // MARK: Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
