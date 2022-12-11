import SwiftUI

struct Cubic : LabelStyle {
    
    @State var glyphBackgroundColor : Color?
    @State var backgroundOpacityLevel : Double?
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .foregroundColor(Color(.black))
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(Color(.white))
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(glyphBackgroundColor ?? Color(.systemGray))
                        .frame(width: 30,height: 30)
                        .opacity(backgroundOpacityLevel ?? 1)
                )
        }
    }
}
