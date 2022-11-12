//
//  GradiantTextField.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 11/11/22.
//

import SwiftUI

struct GradiantTextField: View {
    // MARK: Properties
    @Binding var editingTextfield: Bool
    @Binding var textfieldString: String
    @Binding var iconBounce: Bool
    
    var textfieldPlaceholder: String
    var textfieldIconString: String
    
    private let generator = UISelectionFeedbackGenerator()
    
    // MARK: View
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                TextfieldIcon(iconName: textfieldIconString, currentlyEditing: $editingTextfield, passedImage: .constant(nil))
                    /// Permite ejecutar la animación
                    .scaleEffect(iconBounce ? 1.2 : 1.0)
                
                TextField(textfieldPlaceholder, text: $textfieldString) { isEditing in
                    editingTextfield = isEditing
                    generator.selectionChanged()
                        /// Animación de bounce en el icono
                    if isEditing {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            iconBounce.toggle()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            iconBounce.toggle()
                        }
                    }
                }
                .colorScheme(.dark)
                .foregroundColor(Color.white.opacity(0.6))
            } // HStack
              // .frame(height: 52)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 1.0)
                    .blendMode(.overlay)
            }
            .background(
                //Color("secondaryBackground")
                Color(red: 26/255, green: 20/255, blue: 51/255)
                    .cornerRadius(16)
                //.opacity(0.7)
            )
        }
    }
}

// MARK: Preview
struct GradiantTextField_Previews: PreviewProvider {
    static var previews: some View {
        GradiantTextField(editingTextfield: .constant(true), textfieldString: .constant("Texto aquí"), iconBounce: .constant(false), textfieldPlaceholder: "Text field", textfieldIconString: "textformat.alt")
    }
}
