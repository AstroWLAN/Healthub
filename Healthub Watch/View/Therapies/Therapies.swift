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
    @State private var selectedTherapy : Therapy?
    
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    
    
    var body: some View {
        Group {
            // Empty list placeholder
            if therapyViewModel.connectivityProvider.receivedTherapies.isEmpty {
                VStack(spacing: 0) {
                    Image("TherapiesPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .opacity(0.5)
                        .padding(.vertical, 20)
                    Capsule()
                        .frame(width: 80, height: 30)
                        .foregroundColor(Color("AstroGray"))
                        .overlay(
                            Text("Empty")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(.lightGray))
                        )
                }
            }
            else {
                List {
                    // Header
                    HStack {
                        Text("Therapies")
                            .foregroundColor(Color(.white))
                        Spacer()
                        Image(systemName: "signature")
                    }
                    .font(.system(size: 24, weight: .heavy))
                    .listItemTint(.clear)
                    if interactionsDetected {
                        HStack {
                            Spacer()
                            Image(systemName: "exclamationmark.shield.fill")
                                .font(.system(size: 25,weight: .semibold))
                            Spacer()
                        }
                        .listItemTint(Color("AstroRed"))
                    }
                    ForEach(therapyViewModel.connectivityProvider.receivedTherapies, id: \.self) { therapy in
                        Button(
                            action: {
                                displayTherapyDetails = true
                                selectedTherapy = therapy
                            },
                            label:  {
                                HStack(spacing: 8) {
                                    Text(therapy.name)
                                    Spacer()
                                    if  therapy.interactions.count != 0 {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(Color("AstroRed"))
                                    }
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13,weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .onAppear { if  therapy.interactions.count != 0 { interactionsDetected = true } }
                    }
                }
                .listStyle(.elliptical)
                .onAppear(perform: {
                    therapyViewModel.connectivityProvider.connect()
                })
                .sheet(isPresented: $displayTherapyDetails) {
                    TherapySheet(therapy: $selectedTherapy)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(
                                action: {
                                    displayTherapyDetails = false
                                },
                                label:  {
                                    Text("Close")
                                        .foregroundColor(Color("AstroRed"))
                                }
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("Hub")
    }
}

struct Therapies_Previews: PreviewProvider {
    static var previews: some View {
        Therapies()
    }
}
