import SwiftUI

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

@main
struct HealthubApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
