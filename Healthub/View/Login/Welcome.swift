import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("WelcomeImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                Text("Hello")
                    .font(.largeTitle.bold())
                Text("Welcome to Healthub")
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.bottom, 5)
                Spacer()
                NavigationLink(destination: LoginView()){
                    HStack(spacing: 0) {
                        Image(systemName: "envelope")
                            .font(.system(size: 15,weight: .medium))
                        Text(" Continue with Email")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom,20)
                HStack(spacing: 0){
                    Text("New here? ")
                        .foregroundColor(Color(.systemGray2))
                        .font(.system(size: 15, weight: .semibold))
                    NavigationLink(destination: SignupView()){
                        Text("Signup")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 15, weight: .bold))
                    }
                }
                .padding(.bottom,20)
            }
        }
    }
}

