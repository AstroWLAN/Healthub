import SwiftUI

// View template for the OnBoarding sheet
struct FeatureView: View {
    
    let image : String
    let title : String
    let subtitle : String
    
    var body : some View {
        
        VStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 180)
                .padding(.bottom,20)
            Text(title)
                .font(.system(size: 30,weight: .bold))
            Text(subtitle)
                .font(.system(size: 17,weight: .medium))
                .foregroundColor(Color(.systemGray))
        }
    }
    
}
