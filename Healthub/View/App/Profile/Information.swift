import SwiftUI
import ConfettiSwiftUI

// JSON data structure for AppInformation.json
struct AppInformationJSON : Decodable, Identifiable {
    let id : UUID
    var information : String
    
    enum CodingKeys: CodingKey {
        case id
        case information
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.information = try container.decode(String.self, forKey: .information)
    }
}

struct AppInformationView: View {
    
    @State private var appInformation : [AppInformationJSON] = []
    @State private var confettiCounter : Int = 0
    
    // Decodes the AppInformation.json and creates an array of swift objects
    private func readAppInformation(){
        let jsonDecoder = JSONDecoder()
        guard let dataURL = Bundle.main.url(forResource: "AppInformation", withExtension: "json"),
              let fileData = try? Data(contentsOf: dataURL),
              let jsonData = try? jsonDecoder.decode([AppInformationJSON].self, from: fileData)
        else {
            print("🔥 Something went wrong with the JSON decoding process")
            return
        }
        appInformation = jsonData
    }
    
    var body: some View {
        VStack {
            // Sheet drag icon
            HStack {
                Spacer()
                Capsule()
                    .frame(width: 30, height: 6)
                    .foregroundColor(Color(.systemGray5))
                    .padding(.top,20)
                Spacer()
            }
            Spacer()
            Image("RobotImage")
                .resizable()
                .scaledToFit()
                .frame(width: 129)
                .opacity(0.5)
                .padding(.vertical, 20)
                .accessibility(identifier: "RobotImage")
                .onTapGesture { confettiCounter += 1 }
                .confettiCannon(counter: $confettiCounter,num: 50, confettis: [ConfettiType.text("🤖"), ConfettiType.text("🪐"), ConfettiType.text("🍏")], confettiSize: 20, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
            Text("Healthub")
                .foregroundColor(Color(.systemGray))
                .font(.system(.title, weight: .bold))
                .padding(.bottom, 10)
            
            // App information descriptions
            VStack(spacing: 10){
                ForEach(appInformation) { field in
                    Text(LocalizedStringKey(field.information))
                        .font(.system(size: 13))
                        .foregroundColor(Color(.systemGray2))
                }
                .multilineTextAlignment(.center)
            }
            .navigationBarTitle("Information", displayMode: .inline)
            Spacer()
        }
        .onAppear(perform: readAppInformation)
    }
}
