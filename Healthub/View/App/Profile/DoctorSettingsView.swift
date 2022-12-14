import SwiftUI

struct DoctorSettingsView: View {
    @State private var isEditable : Bool = false
    
    /// **TEMPORARY VARIABLES**
    // Replace these variables with the doctor object from the data model
    @State private var doctorName : String = "Shaun Murphy"
    @State private var healthcode : String = "AM39BZ4"
    @State private var phoneNumber : String = ""
    @State private var address : String = ""
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("GENERALITIES")){
                    Label(doctorName, systemImage: "face.smiling.inverse")
                        .labelStyle(SettingLabelStyle())
                    NavigationLink(destination: AppInformationView()){
                        Label("Information", systemImage: "info.circle.fill")
                            .labelStyle(SettingLabelStyle())
                    }
                }
                .listRowSeparator(.hidden)
                
                Section(header: Text("DOCTOR DATA")){
                    Label(healthcode, systemImage: "stethoscope").labelStyle(SettingLabelStyle())
                    RecordTextfield(textVariable: $phoneNumber,
                                    glyph: "phone.fill",
                                    glyphColor: Color(.white),
                                    glyphBackground: Color(.systemGray),
                                    placeholder: "Phone",
                                    textfieldType: .phone,
                                    badInput: false,
                                    measure: "")
                    RecordTextfield(textVariable: $address,
                                    glyph: "mappin.circle.fill",
                                    glyphColor: Color(.white),
                                    glyphBackground: Color(.systemGray),
                                    placeholder: "Address",
                                    textfieldType: .address,
                                    badInput: false,
                                    measure: "")
                }
                .listRowSeparator(.hidden)
                
            }
            .navigationTitle("Settings")
            .toolbar{
                HStack(spacing: 0){
                    Text("Editable")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color("HealthGray3"))
                        .padding([.leading,.trailing],12)
                        .padding([.top,.bottom],2)
                        .background(Capsule().foregroundColor(Color(.systemGray5)))
                        .opacity(isEditable ? 1 : 0)
                    Button(
                        action: {
                            withAnimation{
                                isEditable.toggle()
                            }
                        },
                        label: {
                            Image(systemName: "loupe")
                                .font(.system(size: 17, weight: .medium))
                            
                        })
                    .foregroundColor(.black)
                }
            }
        }
        .tint(Color(.systemPink))
    }
}

struct DoctorSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorSettingsView()
    }
}
