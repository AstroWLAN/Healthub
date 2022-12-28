import SwiftUI
import Foundation

/*struct Therapy : Hashable {
    let name : String
    let doctor : String
    let duration : String
    let notes : String
    let drugs : [Drug]
    let interactions : [String]
}*/

/*struct Drug : Hashable {
    let id: Int
    let group_description: String
    let ma_holder: String
    let equivalence_group_code: String
    let denomination_and_packaging: String
    let active_principle: String
    let ma_code: String
}
*/
struct Therapies: View {
    
    @State private var displayTherapyDetails : Bool = false
    @State private var interactionsDetected : Bool = false
    
    @State private var userTherapies : [Therapy] = []
    
    var body: some View {
        if userTherapies.isEmpty {
            Image("TherapiesPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .opacity(0.7)
                .padding(.top, 20)
        }
        else {
            List {
                if interactionsDetected {
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 25,weight: .semibold))
                        Spacer()
                    }
                    .listItemTint(Color("AstroRed"))
                }
                ForEach(userTherapies, id: \.self) { therapy in
                    Button(
                        action: {
                            displayTherapyDetails = true
                        },
                        label:  {
                            HStack(spacing: 8) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("AstroRed"))
                                Text(therapy.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13,weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                    .onAppear {
                        if !therapy.interactions.isEmpty {
                            interactionsDetected = true
                        }
                    }
                }
            }
            .listStyle(.elliptical)
            .sheet(isPresented: $displayTherapyDetails) {
                TherapySheet()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(
                            action: {
                                displayTherapyDetails = false
                            },
                            label:  {
                                Text("Close")
                                    .foregroundColor(.pink)
                            }
                        )
                    }
                }
            }
        }
    }
}

struct Therapies_Previews: PreviewProvider {
    static var previews: some View {
        Therapies()
    }
}
