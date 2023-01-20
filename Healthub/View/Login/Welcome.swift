import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                Spacer()
                Image("WelcomeImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.bottom, 20)
                Text("Hello")
                    .font(.system(size: 34, weight: .heavy))
                Text("Welcome to Healthub")
                    .foregroundColor(Color(.systemGray2))
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                // Continue with Email button
                NavigationLink(destination: LoginView()){
                    HStack(spacing: 0) {
                        Image(systemName: "envelope")
                        Text(" Continue with Email")
                            .accessibility(identifier: "ContinueWithEmailButton")
                    }
                    .font(.system(size: 15,weight: .medium))
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom,20)
                // Signup hyperlink
                HStack(spacing: 0) {
                    Text("Newbie? ")
                        .foregroundColor(Color(.systemGray2))
                        .font(.system(size: 15, weight: .medium))
                    NavigationLink(destination: SignupView()){
                        Text("Signup")
                            .accessibility(identifier: "SignupHyperlink")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 15, weight: .bold))
                    }
                    
                }
                .padding(.bottom,20)
            }
        }
    }
}

