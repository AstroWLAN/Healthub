import SwiftUI

struct DoctorLoginView: View {
    
    @State private var email : String = String()
    @State private var password : String = String()
    @State private var healthcode : String = String()
    @State private var isPerformingLogin : Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("DoctorDraw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                Text("Login")
                    .font(.largeTitle.bold())
                Text("We Meet Again Doc")
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                VStack{
                    TextField("\(Image(systemName: "envelope")) Email", text: $email)
                        .padding(.bottom, 10)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    SecureField("\(Image(systemName: "lock")) Password", text: $password)
                        .padding(.bottom, 10)
                        .textContentType(.password)
                    TextField("\(Image(systemName: "123.rectangle")) Healthcode", text: $healthcode)
                        .padding(.bottom, 10)
                        .textContentType(.oneTimeCode)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.default)
                }
                .autocorrectionDisabled(true)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .padding(.vertical, 30)
                Spacer()
                Button(action: {
                    isPerformingLogin = true
                    // Login method
                    isPerformingLogin = false
                },
                       label: {
                    Text("Login")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                })
                .buttonStyle(.borderedProminent)
                .padding(.bottom,40)
                // .disabled() button logic ( empty fields, password mismatch etc... )
                /*
                 Displays signup errors
                 .toast(isPresenting: LoginModelError, duration: 3){
                     AlertToast(displayMode: .hud, type: .systemImage("exclamationmark.circle.fill", Color("HealthGray3")),title: "Signup Failure")
                 }
                */
            }
        }
        .toolbar{
            ProgressView().progressViewStyle(.circular)
                .opacity(isPerformingLogin ? 1 : 0)
        }
    }
}
