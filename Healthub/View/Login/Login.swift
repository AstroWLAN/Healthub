import SwiftUI
import SPIndicator

private enum FocusableObject { case email, codeword }

struct LoginView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var email : String = String()
    @State private var password : String = String()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    // Login form
                    VStack(spacing: 0) {
                        // Header
                        Image("LoginImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220)
                        Text("Login")
                            .font(.system(size: 34, weight: .heavy))
                        Text("Hello Again")
                            .foregroundColor(Color(.systemGray2))
                            .font(.system(size: 17, weight: .semibold))
                        // Fields
                        Spacer()
                        VStack(spacing: 0) {
                            TextField("Email", text: $email)
                                .focused($objectFocused, equals: .email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .padding(.bottom, 10)
                                .accessibility(identifier: "UsernameField")
                            SecureField("Password", text: $password)
                                .focused($objectFocused, equals: .codeword)
                                .textContentType(.password)
                                .keyboardType(.default)
                                .accessibility(identifier: "PasswordField")
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .foregroundColor(Color("AstroGray"))
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                        .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                        Spacer()
                        // Submit button
                        Button(
                            action: {
                                loginViewModel.doLogin(email: email, password: password)
                            },
                            label:  {
                                Text("Login")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom, 20)
                        .disabled(email.isEmpty || password.isEmpty)
                        .accessibility(identifier: "LoginButton")
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.white))
                            .shadow(color: Color(.systemGray4), radius: 1)
                    }
                    // Password restore hyperlink
                    HStack(spacing: 0) {
                        Text("Forgotten Password? ")
                            .foregroundColor(Color(.systemGray2))
                            .font(.system(size: 15, weight: .medium))
                        NavigationLink(destination: RecoverView()) {
                            Text("Recover")
                                .accessibility(identifier: "RecoverHyperlink")
                                .foregroundColor(Color.accentColor)
                                .font(.system(size: 15, weight: .bold))
                        }
                    }
                    .padding(.vertical,20)
                }
                .padding(.top, 15)
            }
        }
        // Displays an alert if the login procedure fails
        .SPIndicator(
            isPresent: $loginViewModel.hasError,
            title: "Error",
            message: "Login Failed",
            duration: 3.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage.init(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
            haptic: .warning,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        )
    }
}
