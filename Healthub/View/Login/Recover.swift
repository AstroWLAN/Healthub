import SwiftUI

private enum FocusableObject { case email }

struct RecoverView: View {
    
    @FocusState private var objectFocused: FocusableObject?
    @EnvironmentObject private var signUpViewModel: SignUpViewModel
    @State private var email : String = String()

    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("PasswordImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160)
                Text("Lost")
                    .font(.largeTitle.bold())
                Text("Reset Your Password")
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                TextField("\(Image(systemName: "envelope")) Email", text: $email)
                    .focused($objectFocused, equals: .email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                    .padding(.vertical, 20)
                Spacer()
                Button(
                    action: {
                        signUpViewModel.recover(email: self.email)
                    },
                    label:  {
                        Text("Recover")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                )
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty ? true : false)
                .padding(.bottom,20)
            }
        }
    }
}

struct Recover_Previews: PreviewProvider {
    static var previews: some View {
        RecoverView()
    }
}
