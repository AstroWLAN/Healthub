import SwiftUI
import TextView

struct Notes: View {
    
    @Environment(\.dismiss) var dismissView
    @FocusState private var descriptionFocused : Bool
    @Binding var doctorNotes : String
    @State private var isWriting : Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Capsule()
                    .frame(width: 30, height: 6)
                    .foregroundColor(Color(.systemGray5))
                    .padding(.top,20)
                Spacer()
            }
            HStack {
                Text("Notes")
                    .font(.largeTitle.bold())
                Spacer()
                Button(
                    action: {
                        dismissView()
                    },
                    label:  {
                        ZStack {
                            Circle()
                                .frame(height: 28)
                                .opacity(0.2)
                            Image(systemName: "paperclip")
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                )
                
            }
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
            TextView(text: $doctorNotes, isEditing: $isWriting, placeholder: "Therapy Description")
                .focused($descriptionFocused)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 20))
        }
        .onAppear(perform: { descriptionFocused = true })
    }
}

struct Notes_Previews: PreviewProvider {
    static var previews: some View {
        Notes(doctorNotes: .constant(String()))
    }
}
