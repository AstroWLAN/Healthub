import SwiftUI

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
        VStack(spacing: 20){
            Image("RobotDraw")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .opacity(0.3)
                .accessibility(identifier: "RobotDraw")
            Text("Healthub")
                .foregroundColor(Color(.systemGray))
                .font(.system(.title2, weight: .bold))
            
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
        }
        .onAppear(perform: readAppInformation)
    }
}

struct AppInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AppInformationView()
    }
}
