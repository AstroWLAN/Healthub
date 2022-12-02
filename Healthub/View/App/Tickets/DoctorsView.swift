import SwiftUI

struct DoctorsView: View {
    
   // let doctors : [String] = ["Shaun Murphy", "Aaron Glassman", "Audrie Lim", "Morgan Reznick", "Marcus Andrews"]
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchQuery : String = ""
    @Binding var selectedDoctor : Doctor?
    
    var body: some View {
        ZStack {
            NavigationStack{
                    List{
                        ForEach(ticketViewModel.doctors, id : \.self){ doctor in
                           //.labelStyle(SettingLabelStyle())
                            Button(
                                action: {
                                    selectedDoctor = doctor
                                    presentationMode.wrappedValue.dismiss()
                                },
                                label:  {
                                    Label(doctor.name, systemImage: "person.fill")
                                        //.labelStyle(SettingLabelStyle())
                                })
                            
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
