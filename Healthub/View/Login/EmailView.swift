//
//  EmailView.swift
//  Healthub
//
//  Created by Dario Crippa on 11/11/22.
//

import SwiftUI

struct EmailView: View {
    
    @State private var email : String = ""
    @State private var password : String = ""
    
    var body: some View {
        VStack{
            Spacer()
            // Illustration
            Image("EmailDraw")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
            // Text
            Group{
                Text("Welcome Back")
                    .font(.largeTitle)
                    .bold()
                    .padding([.top],10)
                Text("Welcome to Healthub")
                    .foregroundColor(Color(.systemGray))
                    .font(.headline)
            }
            Spacer()
            // Login Button
            Button(action: { /* Login Action*/ },
                   label: {
                            Text("Login")
                    .font(.headline)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(.systemPink))
                                        .frame(width: 140,height: 40)
                                )
            })
            .padding([.bottom],40)
        }
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
            .previewDevice("iPhone 13 Pro")
    }
}
