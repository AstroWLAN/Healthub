import SwiftUI

/// ** EXTENSIONS **

// Adds the capability of removing the view from a view stack
extension View {
    @ViewBuilder func isVisible(_ remove: Bool = false) -> some View {
        if remove { self }
        else { }
    }
}

// Removes the back button text in the Navigation Stack
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

/// ** CUSTOM STYLES **

// Colorized custom label inspired by the iOS settings app
struct RainbowLabelStyle : LabelStyle {
    
    let glyphBackground : Color
    let glyphColor : Color
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(glyphColor)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(glyphBackground)
                        .frame(width: 30,height: 30)
                )
        }
    }
}

// Custom label inspired by the iOS settings app
struct SettingLabelStyle : LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(Color(.white))
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(Color(.systemGray))
                        .frame(width: 30,height: 30)
                )
        }
    }
}

// Custom label inspired by the iOS settings app
struct PlainLabelStyle : LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(Color(.systemGray))
        }
    }
}

/// ** CUSTOM VIEWS **

// A view that represents unit of measure
struct UnitMeasureView : View {
    
    let unitMeasure : String
    
    var body : some View {
        ZStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 30,height: 16)
            Text(unitMeasure)
                .font(.system(size: 10,weight: .semibold))
                .foregroundColor(Color("HealthGray3"))
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

// A truly fancy custom textfield to collect medical records and user data
struct RecordTextfield : View {
    
    enum TextfieldType {
        case name, phone, address, pathology, intNumber, floatNumber
    }
    
    static let regexArray = [TextfieldType.name: "^[A-Za-z,-_.\\s]+$", TextfieldType.phone: "^[0-9+]{0,1}+[0-9]{5,16}$"]
    // Inserire una regex per ogni categoria di input
    
    @Binding var textVariable : String
    
    let glyph : String
    let glyphColor : Color
    let glyphBackground : Color
    let placeholder : String
    let textfieldType : TextfieldType
    var badInput : Bool
    let measure : String
    
    
    static func checkInput(type: TextfieldType, str: String) -> Bool{
        switch type{
        case .name:
            let regex = try! NSRegularExpression(pattern: regexArray[TextfieldType.name]!)
            return !regex.matches(str)
        case .phone:
            let regex = try! NSRegularExpression(pattern: regexArray[TextfieldType.phone]!)
            return !regex.matches(str)
        case .address:
            let regex = try! NSRegularExpression(pattern: regexArray[TextfieldType.name]!)
            return !regex.matches(str)
        case .intNumber:
            return Int(str) == nil
        case .floatNumber:
            return Float(str) == nil
        case .pathology:
            let regex = try! NSRegularExpression(pattern: regexArray[TextfieldType.name]!)
            return !regex.matches(str)
            
        }
        
        
    }
    
    var body : some View {
        HStack{
            Label(String(), systemImage: glyph).labelStyle(RainbowLabelStyle(glyphBackground: glyphBackground, glyphColor: glyphColor))
            TextField(placeholder, text: $textVariable)
                .offset(x: -8)
            Spacer()
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 17))
                .foregroundColor(Color(.systemRed))
                .opacity(badInput ? 1 : 0)
            UnitMeasureView(unitMeasure: measure)
                .isVisible(measure.isEmpty ? false : true)
        }
    }
}
    
    @main
    struct HealthubApp: App {
        @StateObject var loginViewModel = LoginViewModel()
        @StateObject var pathologiesViewModel = PathologiesViewModel()
        @StateObject var settingsViewModel = SettingsViewModel()
        var body: some Scene {
            WindowGroup {
                MainView()
                    .environmentObject(loginViewModel)
                    .environmentObject(pathologiesViewModel)
                    .environmentObject(settingsViewModel)
                
            }
        }
    }
