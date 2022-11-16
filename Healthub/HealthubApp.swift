import SwiftUI

// Adds the capability of removing the view from a view stack
extension View {
    
    @ViewBuilder func isVisible(_ remove: Bool = false) -> some View {
        if remove { }
        else { self }
    }
}

// Removes the back button text
extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

/// **Rainbow Label Style**
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

/// **Settings Label Style**
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

/// **Unit Measure View**
// A view that represents a unit of measure
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

/// **RecordTextfield**
// A truly fancy custom textfield used to collect medical records and user data
struct RecordTextfield : View {
    
    enum TextfieldType {
        case name, phone, address
    }
    
    @Binding var textVariable : String
    
    let glyph : String
    let glyphColor : Color
    let glyphBackground : Color
    let placeholder : String
    let textfieldType : TextfieldType
    let badInput : Bool
    let measure : String
    
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
                .isVisible(measure.isEmpty ? true : false)
        }
    }
}

@main
struct HealthubApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
