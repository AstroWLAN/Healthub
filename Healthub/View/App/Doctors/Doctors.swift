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
                        Section(header: Text("Doctors")) {
                            ForEach(Array(contactViewModel.contacts.enumerated()), id: \.element) { index,doctor in
                                HStack(alignment: .firstTextBaseline) {
                                    Label(String(), systemImage: "person.fill")
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(doctor.name!.capitalized)
                                            .font(.system(size: 17,weight: .semibold))
                                            .padding(.bottom, 8)
                                        Text(doctor.address!.capitalized)
                                            .foregroundColor(Color(.systemGray2))
                                            .font(.system(size: 15))
                                        Text(doctor.phone!)
                                            .foregroundColor(Color(.systemGray2))
                                            .font(.system(size: 15))
                                        Text(doctor.email!)
                                            .padding(.top, 8)
                                            .foregroundColor(Color(.systemBlue))
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                // open email app
                                            }
                                    }
                                }
                                .swipeActions{
                                    Button(
                                        role: .destructive,
                                        action: {
                                            contactViewModel.deleteContact(doctor_id: Int(doctor.id))
                                        },
                                        label: { Image(systemName: "trash.fill") })
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .listRowSeparator(.hidden)
                    }
                    .labelStyle(Cubic())
                    .refreshable {
                        // Refresh contact list
                        contactViewModel.fetchContacts(force_reload: true)
                    }
                }
            }
            .sheet(isPresented: $displayDoctorsDatabase, onDismiss: {
                displayDoctorsDatabase = false
                if selectedDoctor != nil {
                    contactViewModel.addContact(doctor_id: Int(selectedDoctor!.id))
                    //contactViewModel.fetchContacts(force_reload: true)
                }
                
            }){
                DoctorsDatabaseView( selectedDoctor: $selectedDoctor, ticketsView: false)
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
           // contactViewModel.fetchContacts(force_reload: false)
            contactViewModel.getDoctorList()
        })
    }
}
