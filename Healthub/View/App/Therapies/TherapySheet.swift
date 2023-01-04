import SwiftUI

struct TherapySheetView: View {
    
    @Binding var therapy : Therapy?
    
    var body: some View {
        
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
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
                    Text("Therapy")
                        .font(.largeTitle.bold())
                    Spacer()
                    Image(systemName: "signature")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(.systemGray4))
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                List {
                    if !therapy!.interactions.isEmpty {
                        Section(header: Text(String()))  {
                            Label("Interactions", systemImage: "exclamationmark.shield.fill")
                            ForEach(therapy!.interactions, id: \.self) { interaction in
                                HStack(alignment: .firstTextBaseline, spacing: 4){
                                    Text(" • ")
                                        .font(.system(size: 17, weight: .bold))
                                    Text(interaction)
                                        .font(.system(size: 15))
                                }
                                .foregroundColor(Color(.white))
                            }
                        }
                        .labelStyle(Cubic(glyphBackgroundColor: .white, glyphColor: Color("AstroRed"), textColor: .white))
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 16))
                        .listRowBackground(Color("AstroRed"))
                        .listRowSeparatorTint(Color("AstroRed"))
                    }
                    Section(header: Text("Generalities")) {
                        Label(therapy!.name.capitalized, systemImage: "cross.vial.fill")
                            .labelStyle(Cubic(glyphBackgroundColor: Color("AstroRed")))
                        Label(therapy!.duration.capitalized, systemImage: "timer")
                            .labelStyle(Cubic())
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    
                    Section(header: Text("Drugs")) {
                        ForEach(Array(therapy!.drugs), id: \.id) { drug in
                            HStack(alignment: .firstTextBaseline) {
                                Label(String(), systemImage: "pill.fill")
                                VStack(alignment: .leading) {
                                    Text(DrugAnalyzer().decomposeDrugName(input: drug.denomination_and_packaging, component: .name).lowercased().capitalized)
                                    Text(DrugAnalyzer().decomposeDrugName(input: drug.denomination_and_packaging, component: .packaging).lowercased().capitalized)
                                        .foregroundColor(Color(.systemGray2))
                                        .font(.system(size: 15))
                                }
                            }
                        }
                    }
                    .labelStyle(Cubic(textHidden: true))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    
                    if !therapy!.notes.isEmpty {
                        Section(header: Text("Notes")) {
                            Text(therapy!.notes)
                                .foregroundColor(Color(.systemGray))
                                .listRowBackground(Color(.systemGray5))
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}
