import SwiftUI
import MapKit

// Creates the ticket inner shape
struct TicketInnerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.05*width, y: 0))
        path.addLine(to: CGPoint(x: 0.34013*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.36702*width, y: 0.009*height), control1: CGPoint(x: 0.35044*width, y: 0), control2: CGPoint(x: 0.36024*width, y: 0.00328*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.05263*height), control1: CGPoint(x: 0.40148*width, y: 0.03809*height), control2: CGPoint(x: 0.44581*width, y: 0.05263*height))
        path.addCurve(to: CGPoint(x: 0.63298*width, y: 0.009*height), control1: CGPoint(x: 0.55419*width, y: 0.05263*height), control2: CGPoint(x: 0.59852*width, y: 0.03809*height))
        path.addCurve(to: CGPoint(x: 0.65987*width, y: 0), control1: CGPoint(x: 0.63976*width, y: 0.00328*height), control2: CGPoint(x: 0.64956*width, y: 0))
        path.addLine(to: CGPoint(x: 0.95*width, y: 0))
        path.addCurve(to: CGPoint(x: width, y: 0.03684*height), control1: CGPoint(x: 0.97761*width, y: 0), control2: CGPoint(x: width, y: 0.01649*height))
        path.addLine(to: CGPoint(x: width, y: 0.96316*height))
        path.addCurve(to: CGPoint(x: 0.95*width, y: height), control1: CGPoint(x: width, y: 0.98351*height), control2: CGPoint(x: 0.97761*width, y: height))
        path.addLine(to: CGPoint(x: 0.05*width, y: height))
        path.addCurve(to: CGPoint(x: 0, y: 0.96316*height), control1: CGPoint(x: 0.02239*width, y: height), control2: CGPoint(x: 0, y: 0.98351*height))
        path.addLine(to: CGPoint(x: 0, y: 0.03684*height))
        path.addCurve(to: CGPoint(x: 0.05*width, y: 0), control1: CGPoint(x: 0, y: 0.01649*height), control2: CGPoint(x: 0.02239*width, y: 0))
        path.closeSubpath()
        return path
    }
}

// Creates a map snapshot for the address
struct AddressView: View {
    
    let location: CLLocationCoordinate2D
    var span: CLLocationDegrees = 0.01
    
    @State private var mapSnapshotImage: UIImage? = nil
    
    var body: some View {
        Group {

            if let mapImage = mapSnapshotImage {
                Image(uiImage: mapImage)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            else {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .frame(width: 230, height: 120)
                    HStack {
                        Spacer()
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
            }
        }
        .onTapGesture {
            let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)")
            if UIApplication.shared.canOpenURL(url!) {
                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
        .onAppear {
            generateMapSnapshot()
        }
    }
    
    // Generates the map snapshot
    func generateMapSnapshot() {
        /// ** Map Options **
        let mapOptions = MKMapSnapshotter.Options()
        // Describes the displayed region
        mapOptions.region = MKCoordinateRegion( center: self.location, span: MKCoordinateSpan( latitudeDelta: self.span, longitudeDelta: self.span ))
        // Describes the size of the map
        mapOptions.size = CGSize(width: 230, height: 120)
        mapOptions.mapType = .standard
        mapOptions.showsBuildings = true
        
        // Generates the Map Snapshot
        MKMapSnapshotter(options: mapOptions).start { (snapshotOrNil, errorOrNil) in
            if let error = errorOrNil {
                print(error)
                return
            }
            if let snapshot = snapshotOrNil {
                self.mapSnapshotImage = snapshot.image
            }
        }
    }
}

struct TicketView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var ticketNumber : Int
    let ticketName : String
    let ticketDoctor : String
    let ticketDate : Date
    let ticketTime : Date
    let ticketLatitude : CLLocationDegrees
    let ticketLongitude : CLLocationDegrees
    
    var body: some View {
        
        ZStack{
            TicketInnerShape()
                .fill(colorScheme == .dark ? .black : .white )
                .padding(8)
            VStack(alignment: .leading){
                Spacer()
                Text(ticketName)
                    .font(.title.bold())
                    .padding(.bottom, 10)
                Group{
                    Text(ticketDoctor)
                    Text("\(ticketDate.formatted(.dateTime.day())) "+"\(ticketDate.formatted(.dateTime.month(.wide))) "+"\(ticketDate.formatted(.dateTime.year()))")
                    Text(ticketTime.formatted(.dateTime.hour().minute()))
                        .padding(.bottom, 10)
                }
                .font(.system(size: 17,weight: .medium))
                .foregroundColor(Color(.systemGray))
                AddressView(location: CLLocationCoordinate2D(latitude: ticketLatitude, longitude: ticketLongitude))
                HStack(spacing: 12){
                    ForEach(0 ..< 3){ _ in
                        Circle().fill(Color(.systemGray6)).frame(height: 6)
                    }
                    Text("Ticket N° \(ticketNumber)")
                        .font(.system(size: 17,weight: .bold))
                        .foregroundColor(Color(.systemGray3))
                    ForEach(0 ..< 3){ _ in
                        Circle().fill(Color(.systemGray6)).frame(height: 6)
                    }
                }
                .padding(16)
            }
            .frame(width: 264,height: 364)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
        .frame(width: 280,height: 380)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 18))
    }
}
