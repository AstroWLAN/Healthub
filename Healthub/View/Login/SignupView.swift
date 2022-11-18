//
//  SignupView.swift
//  Healthub
//
//  Created by Dario Crippa on 11/11/22.
//

import SwiftUI

struct SignupView: View {
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var paswordCheck : String = ""
    
    var body: some View {
        VStack{
            
            // Illustration
            Spacer()
            Image("SignupDraw")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            // Text
            VStack(spacing: 8){
                Text("Welcome").font(.largeTitle).bold()
                Text("Let's get in touch").foregroundColor(Color(.systemGray3))
                .font(.system(size: 17)).bold()
            }
            .padding([.top],20)
            
            // "Continue with Email" button
            Spacer()
            VStack{
                TextField("\(Image(systemName: "envelope")) Email", text: $email)
                    .frame(width: 300)
                    .padding([.bottom],15)
                SecureField("\(Image(systemName: "lock")) Password", text: $password)
                    .frame(width: 300)
                TextField("\(Image(systemName: "lock.rectangle.on.rectangle")) Repeat Password", text: $paswordCheck)
                    .frame(width: 300)
                    .padding([.bottom],15)
            }
            .foregroundColor(Color(.systemGray))
            .multilineTextAlignment(.center)
            .padding(.bottom,80)
            
            Spacer()
            Button(action: { /* login action */ },
                   label: {
                Text("Signup")
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(Color(.white))
                    .padding([.leading,.trailing],34)
                    .padding([.top,.bottom],12)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemPink)))
            })
            .padding(.bottom,20)
            
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
