import SwiftUI
import SPIndicator

private enum FocusableObject { case email }

struct RecoverView: View {
    
    @Environment(\.dismiss) var dismissView
    @EnvironmentObject private var signUpViewModel: SignUpViewModel
    @FocusState private var objectFocused: FocusableObject?
    @State private var email : String = String()
    @State private var emailSent : Bool = false
    
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
                        Image("PasswordImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .padding(EdgeInsets(top: 60, leading: 0, bottom: 20, trailing: 0))
                        Text("Lost")
                            .font(.system(size: 34, weight: .heavy))
                        Text("Reset Your Password")
                            .foregroundColor(Color(.systemGray2))
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        TextField("Email", text: $email)
                            .focused($objectFocused, equals: .email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(Color("AstroGray"))
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
                            .accessibility(identifier: "MailField")
                        Spacer()
                        Button(
                            action: {
                                signUpViewModel.recover(email: self.email)
                                emailSent = true
                                dismissView()
                            },
                            label:  {
                                Text("Recover")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom, 20)
                        .disabled(email.isEmpty ? true : false)
                        .accessibility(identifier: "RecoverButton")
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.white))
                        .shadow(color: Color(.systemGray4), radius: 1)
                }
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 20, trailing: 0))
            }
        }
        .onChange(of: emailSent, perform: { _ in emailSent = false })
        .SPIndicator(
            isPresent: $emailSent,
            title: "Success",
            message: "Email Sent",
            duration: 1.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage.init(systemName: "envelope.circle.fill")!.withTintColor(UIColor(Color(.systemBlue)), renderingMode: .alwaysOriginal)),
            haptic: .success,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        )
    }
}
