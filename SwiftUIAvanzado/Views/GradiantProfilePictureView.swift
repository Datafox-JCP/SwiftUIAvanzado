//
//  GradiantProfilePictureView.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 11/11/22.
//

import SwiftUI

struct GradiantProfilePictureView: View {
    // MARK: Properties
    
    @State private var angle = 0.0
    
    var gradient1: [Color] = [
        Color.init(red: 101/255, green: 134/255, blue: 1),
        Color.init(red: 1, green: 64/255, blue: 80/255),
        Color.init(red: 109/255, green: 1, blue: 185/255),
        Color.init(red: 39/255, green: 232/255, blue: 1),
    ]
    var profilePicture: UIImage
    
    // MARK: View
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: gradient1), center: .center, angle: .degrees(angle))
                .mask(
                Circle()
                    .frame(width: 70, height: 70, alignment: .center)
                    .blur(radius: 8)
                )
                .blur(radius: 8)
                .onAppear() {
                    /// para iniciar la rotación del gradiente
                    withAnimation(.linear(duration: 7)) {
                        self.angle += 360
                    }
                }
            Image(uiImage: profilePicture)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 66, height: 66, alignment: .center)
                .mask(Circle())
                //.clipShape(Circle())
        } // ZStack
    }
}


// MARK: Preview
struct GradiantProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        GradiantProfilePictureView(profilePicture: UIImage(named: "Profile")!)
    }
}
