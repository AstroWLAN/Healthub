import SwiftUI
import AlertToast

private enum FocusableObject { case email, pswd }

struct LoginView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var email : String = String()
    @State private var password : String = String()
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image("LoginImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                Text("Login")
                    .font(.largeTitle.bold())
                Text("We Meet Again")
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                
                VStack{
                    TextField("\(Image(systemName: "envelope")) Email", text: $email)
                        .focused($objectFocused, equals: .email)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding(.bottom, 10)
                    SecureField("\(Image(systemName: "lock")) Password", text: $password)
                        .focused($objectFocused, equals: .pswd)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.default)
                }
                .autocorrectionDisabled(true)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .padding(.vertical, 20)
                Spacer()
                Button(
                    action: { loginViewModel.doLogin(email: email, password: password) },
                    label:  {
                        Text("Login")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                )
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 20)
                .disabled(email.isEmpty || password.isEmpty)
                HStack(spacing: 0){
                    Text("Forgotten password? ")
                        .foregroundColor(Color(.systemGray2))
                        .font(.system(size: 15, weight: .semibold))
                    NavigationLink(destination: RecoverView()){
                        Text("Recover")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 15, weight: .bold))
                    }
                }
                .padding(.bottom,20)
                
            }
            .toast(isPresenting: $loginViewModel.hasError, duration: 3) {
                AlertToast(displayMode: .hud, type: .systemImage("exclamationmark.circle.fill", Color(.black)),title: "Login Failure")
            }
        }
    }
}
