import SwiftUI
import SPIndicator

private enum FocusableObject { case name, code, phone }
private enum MeasureUnit { case kg, cm }
private enum Error { case name, code, phone, none }

struct ProfileView: View {
    
    @EnvironmentObject private var profile : ProfileViewModel
    @EnvironmentObject private var login : LoginViewModel
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    @EnvironmentObject private var therapyViewModel: TherapyViewModel
    @EnvironmentObject private var contactViewModel : ContactViewModel
    @EnvironmentObject private var pathologiesViewModel : PathologyViewModel
    
    @FocusState private var objectFocused: FocusableObject?
    @State private var displayGenderPicker : Bool = false
    @State private var displayHeightPicker : Bool = false
    @State private var displayWeightPicker : Bool = false
    @State private var displayBirthdatePicker : Bool = false
    @State private var displayInformationSheet : Bool = false
    @State private var badInput : Error = .none
    @State private var syncCompleted : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGray6)
                    .ignoresSafeArea()
                // PROFILE
                if profile.isLoading {
                    VStack(spacing:0){
                        Spacer()
                        VStack(spacing:0) {
                            ProgressView().progressViewStyle(.circular)
                                .padding(.bottom, 10)
                                .tint(Color(.systemGray))
                            Text("Loading Profile")
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 17, weight: .medium))
                        }
                        Spacer()
                    }
                }
                else {
                    List {
                        // GENERALITIES section
                        Section(header: Text("Generalities")) {
                            // User Name
                            HStack(spacing: 0) {
                                Label(String(), systemImage: "face.smiling.inverse")
                                TextField("Name", text: $profile.name)
                                    .focused($objectFocused, equals: .name)
                                    .textContentType(.name)
                                    .keyboardType(.default)
                                    .autocorrectionDisabled(true)
                                    .onSubmit {
                                        inputValidation(type: objectFocused!, input: profile.name)
                                        // Updates the patient if the inserted value is accettable
                                        if badInput == .none { profile.updatePatient() }
                                    }
                                    .onChange(of: badInput, perform: { _ in
                                        badInput = .none
                                    })
                                    .SPIndicator(
                                        isPresent: Binding.constant(badInput == .name),
                                        title: "Error",
                                        message: "Bad Input",
                                        duration: 1.5,
                                        presentSide: .top,
                                        dismissByDrag: false,
                                        preset: .custom(UIImage.init(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
                                        haptic: .warning,
                                        layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
                                    )
                            }
                            
                            // User Fiscal Code
                            HStack(spacing: 0) {
                                Label(String(), systemImage: "barcode")
                                TextField("Fiscal Code", text: $profile.fiscalCode)
                                    .focused($objectFocused, equals: .code)
                                    .keyboardType(.default)
                                    .autocorrectionDisabled(true)
                                    .onSubmit {
                                        withAnimation { inputValidation(type: objectFocused!, input: profile.fiscalCode) }
                                        // Updates the patient if the inserted value is accettable
                                        if badInput == .none { profile.updatePatient() }
                                    }
                                    .onChange(of: badInput, perform: { _ in
                                        badInput = .none
                                    })
                                    .SPIndicator(
                                        isPresent: Binding.constant(badInput == .code),
                                        title: "Error",
                                        message: "Bad Input",
                                        duration: 1.5,
                                        presentSide: .top,
                                        dismissByDrag: false,
                                        preset: .custom(UIImage.init(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
                                        haptic: .warning,
                                        layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
                                    )
                            }
                            
                            // User Phone
                            HStack(spacing: 0) {
                                Label(String(), systemImage: "phone.fill")
                                TextField("Phone", text: $profile.phone)
                                    .focused($objectFocused, equals: .phone)
                                    .textContentType(.telephoneNumber)
                                    .keyboardType(.asciiCapable)
                                    .autocorrectionDisabled(true)
                                    .onSubmit {
                                        withAnimation { inputValidation(type: objectFocused!, input: profile.phone) }
                                        if badInput == .none {
                                            // Updates the patient if the inserted value is accettable
                                            profile.updatePatient()
                                        }
                                    }
                                    .onChange(of: badInput, perform: { _ in
                                        badInput = .none
                                    })
                                    .SPIndicator(
                                        isPresent: Binding.constant(badInput == .phone),
                                        title: "Error",
                                        message: "Bad Input",
                                        duration: 1.5,
                                        presentSide: .top,
                                        dismissByDrag: false,
                                        preset: .custom(UIImage.init(systemName: "xmark.circle.fill")!.withTintColor(UIColor(Color("AstroRed")), renderingMode: .alwaysOriginal)),
                                        haptic: .warning,
                                        layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
                                    )
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
                                    profile.getPatient(force_reload: false)
                                    ticketViewModel.fetchTickets(force_reload: false)
                                    therapyViewModel.fetchTherapies(force_reload: false)
                                    contactViewModel.fetchContacts(force_reload: false)
                                    pathologiesViewModel.fetchPathologies(force_reload: false)
                                    syncCompleted = true
                                },
                                label:  {
                                    Label("Synchronize", systemImage: "applewatch")
                                        .labelStyle(Cubic())
                                }
                            )
                            .onChange(of: syncCompleted, perform: { _ in syncCompleted = false })
                            .SPIndicator(
                                isPresent: $syncCompleted,
                                title: "Success",
                                message: "Synchronized",
                                duration: 1.5,
                                presentSide: .top,
                                dismissByDrag: false,
                                preset: .custom(UIImage.init(systemName: "network")!.withTintColor(UIColor(Color(.systemBlue)), renderingMode: .alwaysOriginal)),
                                haptic: .warning,
                                layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
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
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .accessibility(identifier: "ProfileList")
                    .scrollIndicators(.hidden)
                    .navigationTitle("Profile")
                    .refreshable(action: { profile.getPatient(force_reload: false) })
                    .toolbar {
                        Button(
                            action: { displayInformationSheet = true },
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
                    .sheet(isPresented: $displayInformationSheet) { AppInformationView() }
                }
            }
        }
        .tint(Color("AstroRed"))
    }
    
    // Regex validation of the input in the name code and phone fields
    private func inputValidation(type : FocusableObject, input : String) {
        
        let nameRegex = try! Regex("^[A-Z][a-z]+( [A-Z][a-z]+)*$")
        let codeRegex = try! Regex("^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$")
        let phoneRegex = try! Regex("^(\\+\\d{1,3}[- ]?)?\\d{10,}$")
        
        let regexRules : [ FocusableObject : Regex ] = [
            .name : nameRegex,
            .code : codeRegex,
            .phone : phoneRegex
        ]
        
        switch type {
        case .name:
            if (input.wholeMatch(of: regexRules[.name]!) != nil) { badInput = .none }
            else {
                profile.name = String()
                badInput = .name
            }
        case .code:
            if (input.wholeMatch(of: regexRules[.code]!) != nil) { badInput = .none }
            else {
                profile.fiscalCode = String()
                badInput = .code
            }
        case .phone:
            if (input.wholeMatch(of: regexRules[.phone]!) != nil) { badInput = .none }
            else {
                profile.phone = String()
                badInput = .phone
            }
        }
    }
    
    // Adds a unit measure to the value displayed in the weight and height fields
    private func measureComposer(value: String, unit: MeasureUnit) -> String {
        switch unit {
        case .kg:
            if !value.isEmpty {  return value + " Kg" }
            else { return "Weight" }
        case .cm:
            if !value.isEmpty {  return value + " Cm" }
            else { return "Height" }
        }
    }
    
}
