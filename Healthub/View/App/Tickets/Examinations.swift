import SwiftUI


struct ExaminationsSheet : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var selectedExamination : Examination?
    @Binding var selectedExaminationGlyph : String?
    let examGlyphs : [ Examination : String ] = [ .routine : "figure.arms.open", .vaccination : "cross.vial.fill", .sport : "figure.run",
                                                  .specialist : "brain.head.profile", .certificate : "heart.text.square.fill", .other : "magnifyingglass" ]
        
    
    var body: some View {
        ZStack {
            //Color(.systemGray6)
             //   .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Capsule()
                        .frame(width: 30, height: 6)
                        //.foregroundColor(Color(.systemGray5))
                        .padding(.top,20)
                    Spacer()
                }
                List {
                    ForEach(Examination.allCases, id:\.self) { examination in
                        Button(
                            action: {
                                selectedExamination = examination
                                selectedExaminationGlyph = examGlyphs[examination]
                                dismissView()
                            },
                            label:  {
                                HStack {
                                    Label(examination.rawValue.capitalized, systemImage: examGlyphs[examination] ?? "")
                                    Spacer()
                                    Image(systemName: "circle.fill")
                                       // .foregroundColor(Color(.systemGreen))
                                        .font(.system(size: 10))
                                        .opacity(selectionDetection(currentExamination: examination) ? 1 : 0)
                                }
                            }
                        )
                    }
                    .labelStyle(Cubic())
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    //.listRowSeparator(.hidden)
                }
            }
        }
    }
    
    private func selectionDetection(currentExamination : Examination) -> Bool {
        if selectedExamination != nil {
            if selectedExamination! == currentExamination { return true }
            else { return false }
        }
        return false
    }
    
}
