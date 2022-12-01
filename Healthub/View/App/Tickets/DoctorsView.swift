import SwiftUI

struct DoctorsView: View {
    
    let doctors : [String] = ["Shaun Murphy", "Aaron Glassman", "Audrie Lim", "Morgan Reznick", "Marcus Andrews"]
    
    @State private var searchQuery : String = ""
    @Binding var selectedDoctor : String?
    
    var body: some View {
        ZStack {
            NavigationStack{
                    List{
                        ForEach(doctors, id : \.self){ doctor in
                            Label(doctor, systemImage: "person.fill")//.labelStyle(SettingLabelStyle())
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }
                    .searchable(text: $searchQuery, prompt: "Search a Doctor")
            }
            VStack{
                Capsule().frame(width: 40, height: 6).foregroundColor(Color(.systemGray4)).padding(10)
                Spacer()
            }
        }
    }
}
