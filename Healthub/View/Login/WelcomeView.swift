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
                VStack{
                    Text("Hello")
                        .font(.largeTitle.bold())
                    Text("Welcome to Healthub")
                        .foregroundColor(Color(.systemGray))
                        .font(.system(size: 17, weight: .bold))
                        .padding(.bottom, 5)
                    HStack(spacing: 0){
                        Text("Are you a doctor? Please ")
                            .foregroundColor(Color(.systemGray3))
                        NavigationLink(destination : DoctorView()){
                            Text("Sign Here")
                                .foregroundColor(Color(.systemPink))
                        }
                    }
                    .font(.system(size: 15, weight: .bold))
                }
                Spacer()
                NavigationLink(destination: LoginView()){
                    Text("\(Image(systemName: "envelope")) Continue with Email")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 15, weight: .medium))
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.systemPink)))
                        .padding(.bottom,20)
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

