import SwiftUI

struct DrugsDatabase: View {
    
    @Environment(\.dismiss) var dismissPage
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    // Searchbar variables
    @FocusState private var searchFocused : Bool
    @State private var searchQuery : String = String()
    // Drugs Arrays
   // @State private var drugsBuffer : [Drug] = []
    @Binding var drugs : [Drug]
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Drugs")
                        .font(.largeTitle.bold())
                        .padding(.leading, 27)
                    Spacer()
                    Button(
                        action: { dismissPage() },
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
                    .padding(.trailing, 20)
                }
                .padding(.top, 30)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(height: 37)
                    TextField("\(Image(systemName: "magnifyingglass")) Search", text: $searchQuery)
                    .autocorrectionDisabled(true)
                    .textCase(.lowercase)
                    .focused($searchFocused)
                    .padding(.horizontal, 7)
                    .onSubmit {
                        /* Search in the database and retrieve drugs buffer array */
                        therapyViewModel.fetchDrugList(query: searchQuery)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                if searchQuery.isEmpty && therapyViewModel.drugs.isEmpty && drugs.isEmpty {
                    Spacer()
                }
                else {
                    List {
                        if !searchQuery.isEmpty && therapyViewModel.drugs.isEmpty {
                            HStack {
                                Spacer()
                                withAnimation{
                                    Image("EmptySearchPlaceholder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100,height: 100)
                                }
                                Spacer()
                            }
                            .listRowBackground(Color(.clear))
                        }
                        else if !therapyViewModel.drugs.isEmpty {
                            Section(header: Text("Database")) {
                                ForEach(therapyViewModel.drugs, id: \.self) { drug in
                                    Button(
                                        action: {
                                            if !isPresent(chosenDrugs: drugs, currentDrug: drug) {
                                                drugs.insert(drug, at: 0)
                                            }else{
                                                drugs.remove(at: drugs.firstIndex(of: drug)!)
                                            }
                                        },
                                        label:  {
                                            HStack {
                                                Label(drug.denomination_and_packaging, systemImage: "pill.fill").labelStyle(Cubic())
                                                Spacer()
                                                Image(systemName: "circle.fill")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(Color(.systemGreen))
                                                    .opacity(isPresent(chosenDrugs: drugs, currentDrug: drug) ? 1 : 0)
                                            }
                                        }
                                    )
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .listRowSeparator(.hidden)
                        }
                        if !drugs.isEmpty {
                            Section(header: Text("Prescription")) {
                                ForEach(Array(drugs.enumerated()), id: \.element) { index,drug in
                                    Label(drug.denomination_and_packaging, systemImage: "pill.fill").labelStyle(Cubic())
                                        .swipeActions {
                                            Button(
                                                role: .destructive,
                                                action: { drugs.remove(at: index) },
                                                label:  { Image(systemName: "trash.fill") }
                                            )
                                        }
                                }

                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
    
    // Checks if the searched drugs has been already selected for the prescription
    func isPresent( chosenDrugs : [Drug], currentDrug : Drug ) -> Bool {
        if chosenDrugs.contains(currentDrug) { return true }
        return false
    }
}
