import SwiftUI
import AlertToast

struct SettingsView: View {
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    @State private var isFormEditable : Bool = false
    @State private var editButtonAnimates : Bool = false
    
    /// **TEMPORARY VARIABLES**
    /// Replace them with the patient object from the data model
    

    
    var body: some View {
        NavigationStack{
            if(settingsViewModel.isLoading == true){
              AlertToast(type: .loading, title: "Loading")
            }else{
                Form{
                    Section(header: Text("General")){
                        RecordTextfield(textVariable: $settingsViewModel.name, glyph: "face.smiling.inverse",
                                        glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                        placeholder: "Name", textfieldType: .name, badInput: false, measure: "")
                        .disabled(!isFormEditable)
                        
                        // Navigates to the AppInformationView
                        NavigationLink(destination: AppInformationView()){
                            Label("Information", systemImage: "info.circle.fill")
                                .labelStyle(SettingLabelStyle())
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    
                    Section(header: Text("Medical Records")){
                        
                        // User gender picker
                        Picker("Gender", selection: $settingsViewModel.gender) {
                            ForEach(Genders.allCases, id:\.self) { item in
                                Text("\(item.rawValue)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .disabled(!isFormEditable)
                        .padding(.top,5)
                        
                        // User height textfield
                        RecordTextfield(textVariable: $settingsViewModel.height, glyph: "ruler.fill",
                                        glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                        placeholder: "Height", textfieldType: .name, badInput: false, measure: "Cm")
                        .disabled(!isFormEditable)
                        
                        // User weight textfield
                        RecordTextfield(textVariable: $settingsViewModel.weight, glyph: "scalemass.fill",
                                        glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                        placeholder: "Weight", textfieldType: .name, badInput: false, measure: "Kg")
                        .disabled(!isFormEditable)
                        
                        // User fiscal code textfield
                        RecordTextfield(textVariable: $settingsViewModel.fiscalCode, glyph: "123.rectangle.fill",
                                        glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                        placeholder: "Fiscal Code", textfieldType: .name, badInput: false, measure: "")
                        .disabled(!isFormEditable)
                        
                        // User phone number textfield
                        RecordTextfield(textVariable: $settingsViewModel.phone, glyph: "phone.fill",
                                        glyphColor: Color(.white), glyphBackground: Color(.systemGray),
                                        placeholder: "Phone Number", textfieldType: .name, badInput: false, measure: "")
                        .disabled(!isFormEditable)
                        
                        // User phone number textfield
                        DatePicker(selection: $settingsViewModel.birthday, in: ...Date(), displayedComponents: .date) {
                            Label("Birthday",
                                  systemImage: "calendar").labelStyle(SettingLabelStyle())
                        }
                        .disabled(!isFormEditable)
                        
                        // Navigates to the PathologiesView
                        NavigationLink(destination: PathologiesView()){
                            Label("Pathologies", systemImage: "allergens.fill")
                                .labelStyle(SettingLabelStyle())
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    
                    Section {
                        Button(action: {
                            let result = loginViewModel.doLogout()
                        },
                               label:  {
                            Label("Sign Out", systemImage: "xmark.circle.fill")
                                .labelStyle(RainbowLabelStyle(glyphBackground: Color(.systemPink),glyphColor: Color(.white)))
                                .foregroundColor(Color(.systemPink))
                        })
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    
                    
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Settings")
                .toolbar{
                    Button( action: {
                        // Enables form editing and its animation
                        editButtonAnimates.toggle()
                        if(editButtonAnimates == false){
                            settingsViewModel.updatePatient()
                        }
                        withAnimation(editButtonAnimates ? Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default) {
                            isFormEditable.toggle() }},
                            label:  {
                        Image(systemName: "loupe")
                            .font(.system(size: 17, weight: .medium))
                        .rotationEffect(.degrees(isFormEditable ? 15 : 0)) })
                    .foregroundColor(.black)
                    .buttonStyle(.plain)
                }
            }
        }.onAppear(perform: {
            settingsViewModel.getPatient()
        })
        .tint(Color(.systemPink))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
