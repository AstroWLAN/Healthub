import SwiftUI

struct ExaminationsSheet : View {
    
    @Environment(\.dismiss) var dismissView
    @Binding var selectedExamination : Examination?
    @Binding var selectedExaminationGlyph : String?
    
    var body: some View {
        // Examinations list
        List {
            ForEach(Examination.allCases, id:\.self) { examination in
                Button(
                    action: {
                        selectedExamination = examination
                        selectedExaminationGlyph = ExamGlyph().generateGlyph(name: examination.rawValue)
                        dismissView()
                    },
                    label:  {
                        HStack {
                            Label(examination.rawValue.capitalized, systemImage: ExamGlyph().generateGlyph(name: examination.rawValue))
                            Spacer()
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color(.systemGreen))
                                .font(.system(size: 10))
                                .opacity(selectionDetection(currentExamination: examination) ? 1 : 0)
                        }
                    }
                )
            }
            .labelStyle(Cubic())
            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .listRowSeparator(.hidden)
        }
        .accessibilityIdentifier("ExaminationsList")
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
    }
    
    // Detects if an examination has been already selected
    private func selectionDetection(currentExamination : Examination) -> Bool {
        if selectedExamination != nil {
            if selectedExamination! == currentExamination { return true }
            else { return false }
        }
        return false
    }
}


