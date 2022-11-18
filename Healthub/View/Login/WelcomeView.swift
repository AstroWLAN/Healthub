import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                
                // Illustration
                Spacer()
                Image("WelcomeDraw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                
                // Text
                VStack{
                    Text("Hello").font(.largeTitle).bold()
                    Text("Welcome to Healthub").foregroundColor(Color(.systemGray)).font(.system(size: 17)).bold()
                }
                .padding([.top],20)
                
                // "Continue with Email" button
                Spacer()
                NavigationLink(destination: LoginView()){
                    Text("\(Image(systemName: "envelope")) Continue with Email")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(Color(.white))
                        .padding([.leading,.trailing],34)
                        .padding([.top,.bottom],12)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemPink)))
                        .padding(.bottom,40)
                }
                
                
                // Other login option
                HStack(spacing: 0){
                    Text("Are you a doctor? Please ").foregroundColor(Color(.systemGray3)).bold()
                    NavigationLink(destination : DoctorView()){
                        Text("Sign Here").foregroundColor(Color(.systemPink)).bold()
                    }
                }
                .padding(.bottom,20)
                .font(.system(size: 15))
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .previewDevice("iPhone 13 Pro")
    }
}
