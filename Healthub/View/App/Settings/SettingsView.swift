import SwiftUI

// User gender types
enum Genders : String, RawRepresentable, CaseIterable {
    case Male, Female, Other
}

struct SettingsView: View {
    
    @State private var isFormEditable : Bool = false
    @State private var isEditButtonAnimating : Bool = false
    
    /// **TEMPORARY VARIABLES**
    // Replace them with the patient object from the data model
    @State private var name : String = ""
    @State private var gender : Genders = .Male
    @State private var height : String = ""
    @State private var weight : String = ""
    @State private var birthday : Date = Date()
    @State private var fiscalCode : String = ""
    @State private var phone : String = ""
    
    var body: some View {
        NavigationStack{
            Form{
                /// ** GENERAL SECTION **
                Section(header: Text("General")){
                    
                    /// ** User Name Field **
                    RecordTextfield(textVariable: $name, glyph: "face.smiling.inverse",
                                    glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                    placeholder: "Name", textfieldType: .name, badInput: false, measure: "")
                    .disabled(!isFormEditable)
                    
                    // Goes to app Information View
                    NavigationLink(destination: AppInformationView()){
                        Label("Information", systemImage: "info.circle.fill")
                            .labelStyle(SettingLabelStyle())
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                /// ** MEDICAL RECORDS SECTION **
                Section(header: Text("Medical Records")){
                    
                    /// **User Gender Picker**
                    Picker("Gender", selection: $gender) {
                        
                        ForEach(Genders.allCases, id:\.self) { item in
                            Text("\(item.rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .disabled(!isFormEditable)
                    .padding(.top,5)
                    
                    /// **User Height Field**
                    RecordTextfield(textVariable: $height, glyph: "ruler.fill",
                                    glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                    placeholder: "Height", textfieldType: .name, badInput: false, measure: "Cm")
                    .disabled(!isFormEditable)
                    
                    /// **User Weight Field**
                    RecordTextfield(textVariable: $weight, glyph: "scalemass.fill",
                                    glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                    placeholder: "Height", textfieldType: .name, badInput: false, measure: "Kg")
                    .disabled(!isFormEditable)
                    
                    /// **User Fiscal Code Field**
                    RecordTextfield(textVariable: $fiscalCode, glyph: "123.rectangle.fill",
                                    glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                    placeholder: "Fiscal Code", textfieldType: .name, badInput: false, measure: "")
                    .disabled(!isFormEditable)
                    
                    /// **User Phone Number Field**
                    RecordTextfield(textVariable: $phone, glyph: "phone.fill",
                                    glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                    placeholder: "Phone Number", textfieldType: .name, badInput: false, measure: "")
                    .disabled(!isFormEditable)
                    
                    /// **User Birthday Picker**
                    DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
                        Label("Birthday",
                              systemImage: "calendar").labelStyle(SettingLabelStyle())
                    }
                    .disabled(!isFormEditable)
                    
                    NavigationLink(destination: PathologiesView()){
                        Label("Pathologies", systemImage: "allergens.fill")
                            .labelStyle(SettingLabelStyle())
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                /// ** SIGN OUT **
                Section{
                    Button(action: { /* Sign Out action */ },
                           label: {
                                Label("Sign Out", systemImage: "xmark.circle.fill")
                                    .labelStyle(RainbowLabelStyle(glyphBackground: Color(.systemPink),glyphColor: Color(.white)))
                                    .foregroundColor(Color(.systemPink))
                    })
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                        
                
            }
            .navigationTitle("Settings")
            .toolbar{
                Button( action: {
                            // Enables form editing and its animation
                            isEditButtonAnimating.toggle()
                            withAnimation(isEditButtonAnimating ? Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default) {
                                isFormEditable.toggle() }
                        },
                        label: {
                            Image(systemName: "loupe")
                                .font(.system(size: 17, weight: .medium))
                                .rotationEffect(.degrees(isFormEditable ? 15 : 0))
                        })
                .foregroundColor(.black)
                .buttonStyle(.plain)
            }
        }
        .tint(Color(.systemPink))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
