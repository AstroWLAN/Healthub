import SwiftUI

struct DoctorsDatabaseView: View {
    
    @Environment(\.dismiss) var sheetDismiss
    @EnvironmentObject private var contactViewModel : ContactViewModel
    @FocusState var searchFocus : Bool
    @Binding var selectedDoctor : Doctor?
    @State private var searchQuery : String = String()
    @State private var isTyping : Bool = false
    
    // Fill this array with doctors among whom to search for
    /*let docbase : [Doctor] = [
        Doctor(id: 0, name: "Shaun Murphy", address: String()),
        Doctor(id: 1, name: "Marcus Andrews", address: String()),
        Doctor(id: 2, name: "Audrie Lim", address: String()),
        Doctor(id: 3, name: "Meredith Gray", address: String())
    ]*/
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(height: 37)
                HStack{
                    TextField("\(Image(systemName: "magnifyingglass")) Search a Doctor", text: $searchQuery){ startedEditing in
                        if startedEditing {
                            withAnimation {
                                isTyping = true
                            }
                        }
                    } onCommit: {
                        withAnimation {
                            isTyping = false
                        }
                    }
                    .font(.system(size: 17, weight: .medium))
                    .autocorrectionDisabled(true)
                    .keyboardType(.asciiCapable)
                    .focused($searchFocus)
                    Spacer()
                    Button(action: { searchQuery = String()
                        withAnimation {
                            isTyping = false
                        }
                    },
                           label:  {
                        Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15)) }
                    )
                    .opacity(isTyping ? 1 : 0)
                }
                .padding(.horizontal, 10)
                .foregroundColor(Color(.systemGray))
            }
            .padding(.top, 30)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            Spacer()
            List{
                ForEach(self.contactViewModel.doctors.filter({ (doctor: Doctor) -> Bool in
                    return doctor.name!.hasPrefix(searchQuery) || searchQuery == ""
                }), id: \.self) { doctor in
                    Button(action: {
                        selectedDoctor = doctor
                        sheetDismiss()
                        contactViewModel.addContact(doctor_id: Int(doctor.id))
                    },
                           label:  { Label(doctor.name!, systemImage: "person.fill").labelStyle(Cubic()) })
                }
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            self.contactViewModel.getDoctorList()
            searchFocus = true
            
        })
    }
}
