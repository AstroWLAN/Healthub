import SwiftUI

struct Cubic : LabelStyle {
    
    @Environment(\.colorScheme) var colorScheme
    @State var glyphBackgroundColor : Color?
    @State var glyphColor : Color?
    @State var textColor : Color?
    @State var glyphOpacityLevel : Double?
    @State var backgroundOpacityLevel : Double?
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .foregroundColor(textColor ?? Color(.black))
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(glyphColor ?? Color(.white))
                .opacity(glyphOpacityLevel ?? 1)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(glyphBackgroundColor ?? Color(.systemGray))
                        .frame(width: 27,height: 27)
                        .opacity(backgroundOpacityLevel ?? 1)
                )
        }
    }
}
