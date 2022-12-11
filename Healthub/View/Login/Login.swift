import SwiftUI
import AlertToast

struct LoginView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @State private var email : String = String()
    @State private var password : String = String()
    @State private var isPerformingLogin : Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image("EmailDraw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                Text("Login")
                    .font(.largeTitle.bold())
                Text("We Meet Again")
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
                        .textContentType(.password)
                }
                .autocorrectionDisabled(true)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .padding(.vertical, 30)
                Spacer()
                Button(action: {
                    isPerformingLogin = true
                    loginViewModel.doLogin(email: email, password: password)
                    isPerformingLogin = false
                },
                       label: {
                    Text("Login")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                })
                .buttonStyle(.borderedProminent)
                .padding(.bottom,20)
                .disabled(email.isEmpty || password.isEmpty)
                HStack(spacing: 0){
                    Text("New here? Please ")
                        .foregroundColor(Color(.systemGray3))
                    NavigationLink(destination: SignupView()){
                        Text("Signup")
                            .foregroundColor(Color(.systemPink))
                    }
                }
                .font(.system(size: 15, weight: .bold))
                .padding(.bottom,20)
            }
            .toast(isPresenting: $loginViewModel.hasError, duration: 3){
                AlertToast(displayMode: .hud, type: .systemImage("exclamationmark.circle.fill", Color("HealthGray3")),title: "Bad Credentials")
            }
        }
        .toolbar{
            ProgressView().progressViewStyle(.circular)
                .opacity(isPerformingLogin ? 1 : 0)
        }
    }
}
