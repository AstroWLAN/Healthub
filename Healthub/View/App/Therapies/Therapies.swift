import SwiftUI

struct Therapy { /* Therapy Object */ }

struct TherapiesView: View {
    
    @State private var therapies : [Therapy] = []
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                if therapies.isEmpty {
                    Image("TherapiesPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .opacity(0.2)
                        .padding(.bottom, 30)
                }
                else {
                    // Therapies slideshow
                }
                Spacer()
            }
            .navigationTitle("Therapies")
            .toolbar{
                NavigationLink(destination: Prescription()) {
                    ZStack {
                        Circle()
                            .frame(height: 28)
                            .opacity(0.2)
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .medium))
                    }
                }
            }
        }
        .tint(Color(.systemPink))
    }
}

struct TherapiesView_Previews: PreviewProvider {
    static var previews: some View {
        TherapiesView()
    }
}
