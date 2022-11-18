import SwiftUI

struct LoginView: View {
    
    @State private var email : String = ""
    @State private var password : String = ""
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack{
            
            // Illustration
            Spacer()
            Image("EmailDraw")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            // Text
            VStack(spacing: 8){
                Text("Welcome Back").font(.largeTitle).bold()
                HStack(spacing: 0){
                    Text("New here? Please ").foregroundColor(Color(.systemGray3))
                    NavigationLink(destination: SignupView()){
                        Text("Signup").foregroundColor(Color(.systemPink))
                    }
                }
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
            }
            .foregroundColor(Color(.systemGray))
            .multilineTextAlignment(.center)
            .padding(.bottom,80)
            
            Spacer()
            Button(action: { /* login action */
                loginViewModel.doLogin(email: email, password: password)
                print(loginViewModel.isSigned)
                UserDefaults.standard.set(loginViewModel.isSigned, forKey: "isLogged")
            },
                   label: {
                Text("Login")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
