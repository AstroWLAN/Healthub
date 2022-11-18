import SwiftUI

// Creates a custom card shape
struct ContactCard : View {
    
    var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 280,height: 380)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 10).frame(width: 60,height: 20)
                .offset(y: -160)
                .blendMode(.destinationOut)
        }
        .compositingGroup()
        .shadow(color: Color(.systemGray5), radius: 8)
    }
    
}

struct ContactsView: View {
    var body: some View {
        ZStack{
            ContactCard()
            VStack{
                Image("Shaun")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100,height: 100)
                    .clipShape(Circle())
                Text("Shaun Murphy")
                    .font(.title.bold())
                Text("Surgeon")
                Text("339204932")
                Text("Via Golgi 47")
            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
