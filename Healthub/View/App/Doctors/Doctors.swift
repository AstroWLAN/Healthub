import SwiftUI

struct DoctorsView: View {
    
    @State private var displayDoctorsDatabase : Bool = false
    @State private var selectedDoctor : Doctor?
    @State private var doctors : [Doctor] = []
    
    var body: some View {
        NavigationStack {
            VStack{
                if doctors.isEmpty {
                    Image("DoctorsPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .padding(.bottom, 80)
                }
                else {
                    ForEach(Array(doctors.enumerated()), id: \.element) { index,doctor in
                        HStack(alignment: .firstTextBaseline) {
                            Label(String(), systemImage: "person.fill")
                            VStack(alignment: .leading) {
                                Text(doctor.name!.capitalized)
                                Text(doctor.address!.capitalized)
                                    .foregroundColor(Color(.systemGray2))
                                    .font(.system(size: 15))
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $displayDoctorsDatabase,onDismiss: { displayDoctorsDatabase = false }){
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
    }
}
