import SwiftUI

struct ToggleNavigationBar : View {
    
    @Binding var toggleVariable : Bool
    let viewTitle : String
    let actionGlyph : String
    
    var body : some View {
        VStack{
            HStack{
                Text(" ")
                Spacer()
            }
            .font(.system(size: 17,weight: .medium))
            .foregroundColor(Color(.systemGray2))
            HStack(alignment: .lastTextBaseline){
                Text(viewTitle)
                    .font(.largeTitle.bold())
                Spacer()
                Button(action: { toggleVariable = true },
                       label:  { Image(systemName: actionGlyph) })
                    .font(.title2)
                    .tint(Color(.systemPink))
            }
        }
        .padding()
    }
}

struct DoctorsGalleryView: View {
    
    @State private var displayDoctorsDatabase : Bool = false
    @State private var selectedDoctor : Doctor?
    
    var body: some View {
        VStack{
            ToggleNavigationBar(toggleVariable: $displayDoctorsDatabase, viewTitle: "Doctors", actionGlyph: "person.crop.circle.badge.plus")
            Spacer()
            Text(selectedDoctor?.name ?? "Hello, Doctors 🩻").bold()
            Spacer()
        }
        .sheet(isPresented: $displayDoctorsDatabase,onDismiss: { displayDoctorsDatabase = false }){
            DoctorsDatabaseView( selectedDoctor: $selectedDoctor)
                .presentationDragIndicator(.visible)
                .presentationDetents([.large])
            
        }
    }
}

struct DoctorsGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorsGalleryView()
    }
}
