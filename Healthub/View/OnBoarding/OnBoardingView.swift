import SwiftUI

// Structure that represents an OnBoarding.json object
struct OnBoardingData : Decodable, Identifiable, Hashable {
    let id : UUID
    let image : String
    let title : String
    let subtitle : String
    
    enum CodingKeys: CodingKey {
        case image
        case title
        case subtitle
    }
    
    // Custom initializer : generates an UUID programmatically
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.image = try container.decode(String.self, forKey: .image)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
    }
}

struct OnBoardingView: View {
    
    // Initializer : generates a PageIndexViewStyl with custom colors
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(.systemGray))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(.systemGray4))
    }
    
    // Array of objects extracted from OnBoarding.json
    @State private var information : [OnBoardingData] = []
    @State private var currentPage : Int = 0
    
    // Decodes the OnBoarding.json and creates an array of swift objects
    private func readOnBoardingInfo(){
        let jsonDecoder = JSONDecoder()
        guard let dataURL = Bundle.main.url(forResource: "OnBoarding", withExtension: "json"),
              let fileData = try? Data(contentsOf: dataURL),
              let jsonData = try? jsonDecoder.decode([OnBoardingData].self, from: fileData)
        else {
            print("🔥 Something went wrong with the JSON decoding process")
            return
        }
        information = jsonData
    }
    
    var body: some View {
        VStack{
            Spacer()
            TabView(selection: $currentPage.animation()){
                ForEach(Array(information.enumerated()), id: \.element) { pageNumber,data in
                    FeatureView(image: data.image, title: data.title, subtitle: data.subtitle)
                        .tag(pageNumber)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode:.always))
            .frame(height: 400)
            Spacer()
            Button(
                action: {
                    /* Request notifications permissions */
                    
                    // Disable OnBoarding TabView and dismisses it
                    UserDefaults.standard.set(false, forKey: "firstAppLaunch")
                    
                },
                label: {
                    Text("Configure")
                        .padding([.leading,.trailing],30)
                        .padding([.top,.bottom],5)
                        .font(.system(.headline))
                }
            )
            .buttonStyle(.borderedProminent)
            .tint(Color("HealthGray3"))
            .padding(.bottom,20)
            // Displays the "Configure" botton IFF the current page is the one about notifications
            .opacity(currentPage != 3 ? 0 : 1)
        }
        // Avoids that the user dismisses the modal with a swipe
        .interactiveDismissDisabled()
        .onAppear(perform: {
            // Loads the TabView AFTER the OnBoarding.json decoding has ended
            DispatchQueue.main.async {
                readOnBoardingInfo()
            }
        })
    }
}
