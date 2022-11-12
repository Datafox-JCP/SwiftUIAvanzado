    //
    //  SettingsView.swift
    //  SwiftUIAvanzado
    //
    //  Created by Juan Hernandez Pazos on 11/11/22.
    //

import SwiftUI

struct SettingsView: View {
        // MARK: Properties
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
    
    private let geneator = UISelectionFeedbackGenerator()
    
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
                        // Guardar cambios en CoreDta
                    geneator.selectionChanged()
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
    }
}

    // MARK: Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
