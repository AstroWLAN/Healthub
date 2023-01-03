import SwiftUI
import AlertToast

private enum FocusableObject { case email, pswd, repeatpswd }
struct SignupView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject private var signUpViewModel: SignUpViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var email : String = String()
    @State private var password : String = String()
    @State private var passwordCheck : String = String()
    
    @State private var isPerformingSignup : Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("SignupImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                Text("Welcome")
                    .font(.largeTitle.bold())
                Text("Hello There")
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                
                VStack{
                    TextField("\(Image(systemName: "envelope")) Email", text: $email)
                        .focused($objectFocused, equals: .email)
                        .textContentType(.username)
                        .keyboardType(.emailAddress)
                        .padding(.bottom, 10)
                    SecureField("\(Image(systemName: "lock")) Password", text: $password)
                        .focused($objectFocused, equals: .pswd)
                        .textContentType(.password)
                        .padding(.bottom, 10)
                    SecureField("\(Image(systemName: "lock.rectangle.on.rectangle")) Repeat Password", text: $passwordCheck)
                        .focused($objectFocused, equals: .repeatpswd)
                        .textContentType(.password)
                }
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .padding(.vertical, 20)
                .toast(isPresenting: $signUpViewModel.userCreated, alert:{
                    AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", Color(.black)),title: "Account Created")
                })
                .toast(isPresenting: $signUpViewModel.notificationErrorSignUp, alert:{
                    AlertToast(displayMode: .hud, type: .systemImage("xmark.circle.fill", Color(.black)),title: signUpViewModel.errorType.capitalized)
                })
                Spacer()
                Button(
                    action: {
                        signUpViewModel.signUp(email: self.email, password: self.password)
                    },
                    label:  {
                        Text("Signup")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                )
                .buttonStyle(.borderedProminent)
                .disabled(password != passwordCheck ? true : false)
                .padding(.bottom,40)
            }
        }
    }
}
