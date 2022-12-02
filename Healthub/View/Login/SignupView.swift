import SwiftUI
import AlertToast

struct SignupView: View {
    
    @State private var email : String = String()
    @State private var password : String = String()
    @State private var paswordCheck : String = String()
    @State private var isPerformingSignup : Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("SignupDraw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                Text("Welcome")
                    .font(.largeTitle.bold())
                Text("Let's Get in Touch")
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
                    SecureField("\(Image(systemName: "lock.rectangle.on.rectangle")) Repeat Password", text: $paswordCheck)
                        .textContentType(.password)
                }
                .autocorrectionDisabled(true)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .padding(.vertical, 30)
                Spacer()
                Button(action: {
                    isPerformingSignup = true
                    // Signup method
                    isPerformingSignup = false
                },
                       label: {
                    Text("Signup")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                })
                .buttonStyle(.borderedProminent)
                .padding(.bottom,40)
                // .disabled() button logic ( empty fields, password mismatch etc... )
                /*
                 Displays signup errors
                 .toast(isPresenting: SignupModelError, duration: 3){
                     AlertToast(displayMode: .hud, type: .systemImage("exclamationmark.circle.fill", Color("HealthGray3")),title: "Signup Failure")
                 }
                */
            }
        }
        .toolbar{
            ProgressView().progressViewStyle(.circular)
                .opacity(isPerformingSignup ? 1 : 0)
        }
    }
}
