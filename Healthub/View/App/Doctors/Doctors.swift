import SwiftUI

struct DoctorsView: View {
    
    @State private var displayDoctorsDatabase : Bool = false
    @State private var selectedDoctor : Doctor?
    @EnvironmentObject private var contactViewModel : ContactViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    if contactViewModel.contacts.isEmpty {
                        VStack(spacing: 0) {
                            Image("ContactsPlaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0))
                                .accessibilityIdentifier("ContactsPlaceholder")
                            Capsule()
                                .frame(width: 80, height: 30)
                                .foregroundColor(Color(.systemGray5))
                                .overlay(
                                    Text("Empty")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(.systemGray))
                                )
                        }
                        .padding(.bottom, 60)
                    }
                    else {
                        List {
                            Section(header: Text("Doctors")) {
                                ForEach(Array(contactViewModel.contacts.enumerated()), id: \.element) { index,doctor in
                                    HStack(alignment: .firstTextBaseline) {
                                        Label(String(), systemImage: "person.fill")
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(doctor.name!.capitalized)
                                                .font(.system(size: 17))
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
                                        }
                                    }
                                    .swipeActions{
                                        Button(
                                            role: .destructive,
                                            action: { contactViewModel.deleteContact(doctor_id: Int(doctor.id)) },
                                            label: { Image(systemName: "trash.fill") }
                                        )
                                        .accessibilityIdentifier("DeleteDoctorButton")
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .listRowSeparator(.hidden)
                        }
                        .accessibilityIdentifier("ContactsList")
                        .labelStyle(Cubic())
                        .refreshable(action: { contactViewModel.fetchContacts(force_reload: false) })
                    }
                }
                .sheet(
                    isPresented: $displayDoctorsDatabase,
                    onDismiss: {
                        displayDoctorsDatabase = false
                        if selectedDoctor != nil { contactViewModel.addContact(doctor_id: Int(selectedDoctor!.id)) }
                        }
                ){
                    DoctorsDatabaseView( selectedDoctor: $selectedDoctor, ticketsView: false)
                        .presentationDetents([.large])
                    
                }
                .navigationTitle("Contacts")
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
                    .accessibilityIdentifier("AddDoctorButton")
                }
            }
        }
        .tint(Color("AstroRed"))
        .onAppear(perform: { contactViewModel.getDoctorList() })
    }
}
