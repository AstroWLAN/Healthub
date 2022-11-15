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

/// **Healthub Label Style**
// Custom label inspired by the iOS settings app
struct HealthubLabel : LabelStyle {
    
    var labelColor : Color
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(labelColor)
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
        Text(unitMeasure)
            .font(.system(size: 13,weight: .semibold))
            .foregroundColor(Color(.systemGray))
            .padding([.leading,.trailing],14)
            .padding([.top,.bottom],4)
            .background(
                Capsule().foregroundColor(Color(.systemGray5))
            )
    }
}


/// **RecordTextfield**
// A truly fancy custom textfield used to collect medical records and user data
struct RecordTextfield : View {
    
    enum TextfieldType {
        case personName
    }
    
    @Binding var textVariable : String
    
    let glyph : String
    let glyphColor : Color
    let placeholder : String
    let textfieldType : TextfieldType
    let badInput : Bool
    let measure : String
    
    var body : some View {
        HStack{
            Label(String(), systemImage: glyph).labelStyle(HealthubLabel(labelColor: glyphColor))
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
