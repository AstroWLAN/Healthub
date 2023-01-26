import SwiftUI

enum DrugComponent { case name, packaging }

private func decomposeDrugName(input : String, component : DrugComponent) -> String {
    let drugNameComponents = input.components(separatedBy: "*")
    switch component {
    case .name:
        return drugNameComponents[0]
    case .packaging:
        return drugNameComponents[1]
    }
}

struct TherapySheet: View {

    @Binding var therapy: Therapy?
    
    var body: some View {
        TabView {
            // Tab : Therapy generalities
            List {
                // Header
                VStack(alignment: .leading, spacing: 0) {
                    Text(therapy!.name)
                        .font(.system(size: 24, weight: .heavy))
                    Text(therapy!.duration)
                        .font(.system(size: 17, weight: .semibold))
                }
                .listItemTint(.clear)
                // Notes
                Text(therapy!.notes)
                    .foregroundColor(Color(.lightGray))
            }
            .listStyle(.elliptical)
            // Tab : Drugs
            List {
                // Header
                Text("Drugs")
                    .font(.system(size: 24, weight: .heavy))
                    .listItemTint(.clear)
                // Drugs
                ForEach(Array(therapy!.drugs), id:\.self) { drug in
                    
                    VStack(alignment: .leading) {
                        Text(decomposeDrugName(input:drug.denomination_and_packaging, component:.name).lowercased().capitalized)
                        Text(decomposeDrugName(input:drug.denomination_and_packaging, component:.packaging).lowercased().capitalized)
                            .foregroundColor(Color(.gray))
                            .font(.system(size: 15))
                    }
                }
            }
            // Tab : Therapy interactions
            if !therapy!.interactions.isEmpty {
                List {
                    // Header
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 25,weight: .semibold))
                        Spacer()
                    }
                    .listItemTint(Color("AstroRed"))
                    // Interactions
                    ForEach(therapy!.interactions, id: \.self) { interaction in
                        Text(interaction)
                            .foregroundColor(Color(.lightGray))
                    }
                }
                .listStyle(.elliptical)
            }
        }
    }
}
