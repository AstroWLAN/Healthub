import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("WelcomeDraw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                Text("Hello")
                    .font(.largeTitle.bold())
                Text("Welcome to Healthub")
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size: 17, weight: .bold))
                    .padding(.bottom, 5)
                Spacer()
                
                NavigationLink(destination: LoginView()){
                    Text("\(Image(systemName: "envelope")) Continue with Email")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom,20)
                
                HStack(spacing: 0){
                    Text("Are you a doctor? Please ")
                        .foregroundColor(Color(.systemGray3))
                    NavigationLink(destination : DoctorLoginView()){
                        Text("Sign Here")
                            .foregroundColor(Color(.systemPink))
                    }
                }
                .font(.system(size: 15, weight: .bold))
                .padding(.bottom,20)
            }
        }
    }
}

