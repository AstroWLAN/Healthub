import SwiftUI

struct DoctorsGalleryView: View {
    
    @State private var displayDoctorsDatabase : Bool = false
    @State private var selectedDoctor : Doctor?
    @State private var doctors : [Doctor] = []
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                if doctors.isEmpty {
                    Image("DoctorsPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .opacity(0.2)
                        .padding(.bottom, 30)
                }
                else {
                    // Therapies slideshow
                }
                Spacer()
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
                            Image(systemName: "person.fill")
                                .font(.system(size: 13, weight: .medium))
                        }
                    }
                )
            }
        }
        .tint(Color(.systemPink))
    }
}

struct DoctorsGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorsGalleryView()
    }
}
