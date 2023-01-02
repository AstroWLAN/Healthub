import SwiftUI

struct TherapySheet: View {
    
    //@Binding var therapy : Therapy
    @Binding var therapy: Therapy?
    
    var body: some View {
        TabView {
            List {
                VStack(alignment: .leading, spacing: 4) {
                    Text(therapy!.name)
                        .font(.system(size: 23, weight: .bold))
                    Text(therapy!.duration)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                Section(header: Text("Drugs")) {
                    ForEach(Array(therapy!.drugs), id:\.self) { drug in
                        Text(drug.group_description)
                            .lineLimit(4)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            .listStyle(.elliptical)
            if !therapy!.interactions.isEmpty {
                List {
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 25,weight: .semibold))
                        Spacer()
                    }
                    .listItemTint(Color("AstroRed"))
                    ForEach(therapy!.interactions, id: \.self) { interaction in
                        Text(interaction)
                    }
                }
                .listStyle(.elliptical)
            }
            List {
                Text("Notes")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                Text(therapy!.notes)
            }
        }
    }
}
