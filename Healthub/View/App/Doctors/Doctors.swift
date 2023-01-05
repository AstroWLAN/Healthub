import SwiftUI

struct DoctorsView: View {
    
    @State private var displayDoctorsDatabase : Bool = false
    @State private var selectedDoctor : Doctor?
    @EnvironmentObject private var contactViewModel : ContactViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                if contactViewModel.contacts.isEmpty {
                    Image("DoctorsPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .padding(.bottom, 80)
                }
                else {
                    List{
                        ForEach(Array(contactViewModel.contacts.enumerated()), id: \.element) { index,doctor in
                            HStack(alignment: .firstTextBaseline) {
                                Label(String(), systemImage: "person.fill")
                                VStack(alignment: .leading) {
                                    Text(doctor.name!.capitalized)
                                    Text(doctor.address!.capitalized)
                                        .foregroundColor(Color(.systemGray2))
                                        .font(.system(size: 15))
                                    Text(doctor.phone!)
                                        .foregroundColor(Color(.systemGray2))
                                        .font(.system(size: 15))
                                    Text(doctor.email!)
                                        .foregroundColor(Color(.systemGray2))
                                        .font(.system(size: 15))
                                }
                            }.swipeActions{
                                Button(
                                    role: .destructive,
                                    action: {
                                        contactViewModel.deleteContact(doctor_id: Int(doctor.id))
                                    },
                                    label: { Image(systemName: "trash.fill") })
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $displayDoctorsDatabase,onDismiss: {
                displayDoctorsDatabase = false
                contactViewModel.fetchContacts()
                
            }){
                DoctorsDatabaseView( selectedDoctor: $selectedDoctor)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
                
            }
            .navigationTitle("Doctors")
            .toolbar {
                Button(
                    action: { displayDoctorsDatabase = true },
                    label:  {
                        ZStack {
                            Circle()
                                .frame(height: 28)
                                .opacity(0.2)
                            Image(systemName: "plus")
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                )
            }
        }
        .tint(Color("AstroRed"))
        .onAppear(perform: {
            contactViewModel.fetchContacts()
        })
    }
}
