import SwiftUI


struct ExaminationsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isSelected : Bool = false
    @Binding var selectedExam : Examination?
    @Binding var examGlyph : String?
    
    let examGlyphs : [ Examination : String ] = [ .routine : "figure.arms.open", .vaccination : "cross.vial.fill", .sport : "figure.run",
        .specialist : "brain.head.profile", .certificate : "heart.text.square.fill", .other : "magnifyingglass" ]
    
    var body: some View {
        ZStack{
            List{
                Section{
                    ForEach(Examination.allCases, id:\.self){ examination in
                        Button(
                            action: {
                                selectedExam = examination
                                examGlyph = examGlyphs[examination]
                                presentationMode.wrappedValue.dismiss()
                            },
                            label:  {
                                Label(examination.rawValue.capitalized, systemImage: examGlyphs[examination] ?? "")
                                    //.labelStyle(SettingLabelStyle())
                            })
                    }
                }
                .listRowSeparator(.hidden)
            }
            VStack{
                Capsule().frame(width: 40, height: 6).foregroundColor(Color(.systemGray4)).padding(10)
                Spacer()
            }
        }
    }
}
