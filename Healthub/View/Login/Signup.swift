import SwiftUI
import SPIndicator

private enum FocusableObject { case email, codeword, repeatcodeword }

struct SignupView: View {
    
    @Environment(\.dismiss) var dismissView
    @EnvironmentObject private var signUpViewModel: SignUpViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var email : String = String()
    @State private var password : String = String()
    @State private var passwordCheck : String = String()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    // Signup form
                    VStack(spacing: 0) {
                        // Header
                        Image("SignupImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .padding(EdgeInsets(top: 40, leading: 0, bottom: 20, trailing: 0))
                        Text("Welcome")
                            .font(.largeTitle.bold())
                        Text("Hello There")
                            .foregroundColor(Color(.systemGray))
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
                                .padding(.bottom, 10)
                                .accessibility(identifier: "PasswordField")
                            SecureField("Repeat Password", text: $passwordCheck)
                                .focused($objectFocused, equals: .repeatcodeword)
                                .textContentType(.password)
                                .keyboardType(.default)
                                .accessibility(identifier: "RepeatPasswordField")
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
                                signUpViewModel.signUp(email: self.email, password: self.password)
                            },
                            label:  {
                                Text("Signup")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom, 20)
                        .disabled(email.isEmpty || password.isEmpty || passwordCheck.isEmpty)
                        .accessibility(identifier: "SignupButton")
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.white))
                            .shadow(color: Color(.systemGray4), radius: 1)
                    }
                    .padding(.bottom,20)
                }
                .padding(.top, 15)
            }
        }
        .onChange(of: signUpViewModel.userCreated, perform: { _ in
            if signUpViewModel.userCreated { dismissView() }
        })
        // Displays an alert if the signup procedure fails
        .SPIndicator(
            isPresent: $signUpViewModel.errorSignUp,
            title: "Error",
            message: "User Creation Failed",
            duration: 1.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage.init(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
            haptic: .warning,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        )
        // Displays an alert if the signup procedure ends correctly
        .SPIndicator(
            isPresent: $signUpViewModel.userCreated,
            title: "Success",
            message: "User Created",
            duration: 1.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage.init(systemName: "checkmark.circle.fill")!.withTintColor(UIColor(Color(.systemGreen)), renderingMode: .alwaysOriginal)),
            haptic: .warning,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        )
    }
}
