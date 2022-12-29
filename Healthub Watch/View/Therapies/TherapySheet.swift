import SwiftUI

struct TherapySheet: View {
    
    //@Binding var therapy : Therapy
    @State private var therapy: Therapy!
    /*@State private var therapy = Therapy(id: 1, name: "Therapy 1", doctor : nil, duration: "10 days", drugs: [
        Drug(id: 3598,
             group_description: "BECLOMETASONE+FORMOTEROLO 100+6MCG 120 DOSI POLVERE USO RESPIRATORIO",
             ma_holder: "PROMEDICA Srl",
             equivalence_group_code: "I2B",
             denomination_and_packaging: "FORMODUAL*polv inal 120 dosi 100 mcg + 6 mcg nexthaler",
             active_principle: "Beclometasone/formoterolo",
             ma_code: "37778038"),
        Drug(id: 3598,
             group_description: "BECLOMETASONE+FORMOTEROLO 100+6MCG 120 DOSI POLVERE USO RESPIRATORIO",
             ma_holder: "PROMEDICA Srl",
             equivalence_group_code: "I2B",
             denomination_and_packaging: "FORMODUAL*polv inal 120 dosi 100 mcg + 6 mcg nexthaler",
             active_principle: "Beclometasone/formoterolo",
             ma_code: "37778038")
     ], notes: "Un puff mattina e sera ogni giorno", interactions: ["Foster is a doping drug and for this reason you could be disqualified from sport competitions"])*/
    
    var body: some View {
        TabView {
            List {
                VStack(alignment: .leading, spacing: 4) {
                    Text(therapy.name)
                        .font(.system(size: 23, weight: .bold))
                    Text(therapy.duration)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                Section(header: Text("Drugs")) {
                    ForEach(therapy.drugs, id:\.self) { drug in
                        Text(drug.group_description)
                            .lineLimit(4)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            .listStyle(.elliptical)
            if !therapy.interactions.isEmpty {
                List {
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 25,weight: .semibold))
                        Spacer()
                    }
                    .listItemTint(Color("AstroRed"))
                    ForEach(therapy.interactions, id: \.self) { interaction in
                        Text(interaction)
                    }
                }
                .listStyle(.elliptical)
            }
            List {
                Text("Notes")
                    .font(.system(size: 21, weight: .bold))
                    .listItemTint(.clear)
                Text(therapy.notes)
            }
        }
    }
}

struct TherapySheet_Previews: PreviewProvider {
    static var previews: some View {
        TherapySheet()
    }
}
