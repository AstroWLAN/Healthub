import SwiftUI
import AlertToast

private enum FocusableObject { case name, code, phone }
private enum BadObject { case badName, badCode, badPhone, none }
private enum MeasureUnit { case kg, cm }

struct ProfileView: View {
    
    @EnvironmentObject private var profile : ProfileViewModel
    @EnvironmentObject private var login : LoginViewModel
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    @EnvironmentObject private var contactViewModel : ContactViewModel
    @EnvironmentObject private var pathologiesViewModel : PathologyViewModel
    
    @FocusState private var objectFocused: FocusableObject?
    @State private var badInput : BadObject = .none
    @State private var displayGenderPicker : Bool = false
    @State private var displayHeightPicker : Bool = false
    @State private var displayWeightPicker : Bool = false
    @State private var displayBirthdatePicker : Bool = false
    @State private var displayInformationSheet : Bool = false
    
    var body: some View {
        NavigationStack {
            if profile.isLoading {
                AlertToast(type: .loading)
            }
            else{
                List {
                    // GENERALITIES section
                    Section(header: Text("Generalities")) {
                        // User Name
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "face.smiling.inverse")
                            TextField("Name", text: $profile.name)
                                .focused($objectFocused, equals: .name)
                                .textContentType(.name)
                                .keyboardType(.asciiCapable)
                                .onSubmit {
                                    withAnimation { inputValidation(type: objectFocused!, input: profile.name) }
                                    if badInput == .none {
                                       profile.updatePatient()
                                    }
                                }
                            ZStack {
                                Circle()
                                    .frame(height: 20)
                                    .opacity(0.2)
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 10, weight: .bold))
                                
                            }
                            .foregroundColor(Color(.systemRed))
                            .opacity(badInput == .badName ? 1 : 0)
                        }
                        
                        // User Fiscal Code
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "barcode")
                            TextField("Fiscal Code", text: $profile.fiscalCode)
                                .focused($objectFocused, equals: .code)
                                .keyboardType(.asciiCapable)
                                .onSubmit {
                                    withAnimation { inputValidation(type: objectFocused!, input: profile.fiscalCode) }
                                    if badInput == .none {
                                        profile.updatePatient()
                                    }
                                }
                            ZStack {
                                Circle()
                                    .frame(height: 20)
                                    .opacity(0.2)
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(Color(.systemRed))
                            .opacity(badInput == .badCode ? 1 : 0)
                        }
                        
                        // User Phone
                        HStack(spacing: 0) {
                            Label(String(), systemImage: "phone.fill")
                            TextField("Phone", text: $profile.phone)
                                .focused($objectFocused, equals: .phone)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.asciiCapable)
                            ZStack {
                                Circle()
                                    .frame(height: 20)
                                    .opacity(0.2)
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(Color(.systemRed))
                            .opacity(badInput == .badPhone ? 1 : 0)
                        }
                    }
                    .labelStyle(Cubic())
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .listRowSeparator(.hidden)
                    
                    // MEDICAL RECORDS section
                    Section(header: Text("Medical Records")) {
                        
                        // User Gender
                        Button(
                            action: { displayGenderPicker = true },
                            label:  { Label(profile.gender.rawValue.capitalized, systemImage: "person.fill") }
                        )
                        .sheet(isPresented: $displayGenderPicker, onDismiss: { profile.updatePatient() }) {
                            GenderSheet(userGender: $profile.gender).presentationDetents([.height(200)])
                        }
                        .accessibilityIdentifier("Profile_GenderButton")
                        // User Height
                        Button(
                            action: { displayHeightPicker = true },
                            label:  { Label(measureComposer(value: profile.height, unit: .cm), systemImage: "ruler.fill") }
                        )
                        .sheet(isPresented: $displayHeightPicker, onDismiss: { profile.updatePatient() }) {
                            HeightSheet(userHeight: $profile.height).presentationDetents([.height(200)])
                        }
                        .accessibilityIdentifier("Profile_HeightButton")
                        // User Weight
                        Button(
                            action: { displayWeightPicker = true },
                            label:  { Label(measureComposer(value: profile.weight, unit: .kg), systemImage: "scalemass.fill") }
                        )
                        .sheet(isPresented: $displayWeightPicker, onDismiss: { profile.updatePatient() }) {
                            WeightSheet(userWeight: $profile.weight).presentationDetents([.height(200)])
                        }
                        .accessibilityIdentifier("Profile_WeightButton")
                        // User Birthdate
                        Button(
                            action: { displayBirthdatePicker = true },
                            label:  { Label(profile.birthday.formatted(.dateTime.day().month(.wide).year()).capitalized, systemImage: "calendar") }
                        )
                        .sheet(isPresented: $displayBirthdatePicker, onDismiss: { profile.updatePatient() }) {
                            BirthdateSheet(birthdate: $profile.birthday).presentationDetents([.height(200)])
                        }
                        .accessibilityIdentifier("Profile_BirthdayButton")
                        // User Pathologies
                        NavigationLink(destination : PathologiesView()) {
                            Label("Pathologies", systemImage: "allergens.fill")
                        }
                        .accessibilityIdentifier("Profile_PathologiesButton")
                    }
                    .labelStyle(Cubic())
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .listRowSeparator(.hidden)
                    
                    // OTHER section
                    Section(header: Text("Other")) {
                        
                        //Sync with Apple Watch
                        Button(
                            action: {
                                
                            },
                            label:  {
                                Label("Synchronize", systemImage: "applewatch")
                                    .labelStyle(Cubic())
                            }
                        )
                        
                        // Sign Out
                        Button(
                            action: { login.doLogout() },
                            label:  {
                                Label("Sign Out", systemImage: "xmark.circle.fill")
                                    .labelStyle(Cubic(glyphBackgroundColor: Color(.systemPink), textColor: Color(.systemPink)))
                            }
                        )
                        .accessibility(identifier: "SignOut")
                        .buttonStyle(.plain)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .listRowSeparator(.hidden)
                    
                }
                .accessibility(identifier: "ProfileList")
                .scrollIndicators(.hidden)
                .navigationTitle("Profile")
                .toolbar {
                    Button(
                        action: {
                            displayInformationSheet = true
                        },
                        label:  {
                            ZStack {
                                Circle()
                                    .frame(height: 28)
                                    .opacity(0.2)
                                Image(systemName: "info")
                                    .font(.system(size: 13, weight: .medium))
                            }
                        }
                    )
                }
                .sheet(isPresented: $displayInformationSheet) {
                    AppInformationView()
                }
            }
        }
        .tint(Color(.systemPink))
        .onAppear(perform: {
            //profile.getPatient()
            
        })
    }
    
    private func inputValidation(type : FocusableObject, input : String) {
        
        let regexRules : [ FocusableObject : Regex ] = [
            .name : /^([ \u00c0-\u01ffa-zA-Z'\-])+$/,
            .code : /^[a-zA-Z]{6}[0-9]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9]{2}([a-zA-Z]{1}[0-9]{3})[a-zA-Z]{1}$/
        ]
        
        switch type {
        case .name:
            if (input.wholeMatch(of: regexRules[.name]!) != nil) { badInput = .none }
            else {
                profile.name = String()
                badInput = .badName
            }
        case .code:
            if (input.wholeMatch(of: regexRules[.code]!) != nil) { badInput = .none }
            else {
                profile.fiscalCode = String()
                badInput = .badCode
            }
        case .phone:
            if !input.isEmpty { badInput = .none }
            else { badInput = .badPhone }
        }
    }
    
    private func measureComposer(value: String, unit: MeasureUnit) -> String {
        switch unit {
        case .kg:
            if !value.isEmpty {  return value+" kg" }
            else { return "Weight" }
        case .cm:
            if !value.isEmpty {  return value+" cm" }
            else { return "Height" }
        }
    }
    
}
