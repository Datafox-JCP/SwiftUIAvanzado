//
//  ProfileView.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 08/11/22.
//

import SwiftUI

struct ProfileView: View {
    // MARK: Properties
    
    
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
                        ZStack {
                            Circle()
                                .foregroundColor(Color("pink-gradient-1"))
                                .frame(width: 66, height: 66, alignment: .center)
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .medium, design: .rounded))
                        } // ZStack foto
                        .frame(width: 66, height: 66, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text("Juan Carlos Pazos")
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
                            print("Pasar a settings")
                        } label: {
                            TextfieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true))
                        }
                    } // HStack
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text("Instructor en IT formación")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    Label("Tiene 10 certificados desde Diciembre 2021", systemImage: "calendar")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.footnote)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        Image("Twitter")
                            .resizable()
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 24, height: 24, alignment: .center)
                        
                        Image(systemName: "link")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        
                        Text("itformacion.com")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.footnote)
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
                    print ("Cerrar sesión")
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
        .colorScheme(.dark)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
