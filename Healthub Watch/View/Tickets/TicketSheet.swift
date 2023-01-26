import SwiftUI
import MapKit

struct TicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.9*width, y: 0))
        path.addCurve(to: CGPoint(x: width, y: 0.1*height), control1: CGPoint(x: 0.95523*width, y: 0), control2: CGPoint(x: width, y: 0.04477*height))
        path.addLine(to: CGPoint(x: width, y: 0.9*height))
        path.addCurve(to: CGPoint(x: 0.9*width, y: height), control1: CGPoint(x: width, y: 0.95523*height), control2: CGPoint(x: 0.95523*width, y: height))
        path.addLine(to: CGPoint(x: 0.1*width, y: height))
        path.addCurve(to: CGPoint(x: 0, y: 0.9*height), control1: CGPoint(x: 0.04477*width, y: height), control2: CGPoint(x: 0, y: 0.95523*height))
        path.addLine(to: CGPoint(x: 0, y: 0.1*height))
        path.addCurve(to: CGPoint(x: 0.1*width, y: 0), control1: CGPoint(x: 0, y: 0.04477*height), control2: CGPoint(x: 0.04477*width, y: 0))
        path.addLine(to: CGPoint(x: 0.36478*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.085*height), control1: CGPoint(x: 0.389*width, y: 0.05029*height), control2: CGPoint(x: 0.44044*width, y: 0.085*height))
        path.addCurve(to: CGPoint(x: 0.63522*width, y: 0), control1: CGPoint(x: 0.55956*width, y: 0.085*height), control2: CGPoint(x: 0.611*width, y: 0.05029*height))
        path.addLine(to: CGPoint(x: 0.9*width, y: 0))
        path.closeSubpath()
        return path
    }
}

struct MapView : View {
    
    @Binding var ticketRegion : MKCoordinateRegion
    @Binding var ticketMarkers : [Marker]
    @Binding var ticketAddress : String?
    
    var body : some View {
        VStack {
            // Renders the map associated to the address
            Map(coordinateRegion: $ticketRegion, interactionModes: .zoom,annotationItems: ticketMarkers) { marker in
                marker.location
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.vertical, 10)
            Text(ticketAddress!.capitalized)
        }
    }
}

struct TicketSheet: View {
    
    @Binding var ticket : Reservation?
    @State var ticketRegion : MKCoordinateRegion = MKCoordinateRegion()
    @Binding var ticketAddress : String?
    @State var ticketMarkers : [Marker] = []
    
    var body: some View {
        TabView {
            // Tab : Ticket information
            ZStack {
                TicketShape()
                    .padding(10)
                    .foregroundColor(.gray)
                    .opacity(0.2)
                VStack(alignment: .leading, spacing: 8) {
                    Text(ticket!.examinationType.name.capitalized)
                        .font(.system(size: 23, weight: .bold))
                        .padding(.top, 20)
                    Text(ticket!.doctor.name!.capitalized)
                    Text(
                        ticket!.date.formatted(.dateTime.day().month(.wide)).capitalized + " " +
                        ticket!.date.formatted(.dateTime.year())
                    )
                    Text(ticket!.time.formatted(.dateTime.hour().minute()))
                        .padding(.bottom, 20)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            }
            // Tab : MapView
            MapView(ticketRegion: $ticketRegion, ticketMarkers: $ticketMarkers, ticketAddress: $ticketAddress)
        }
        .onAppear(perform:{
            Address2Coordinates.translate(from: ticketAddress!) { (location, error) in
                if let location = location{
                    
                    self.ticketRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude:  location.longitude), span:  MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) )
                    self.ticketMarkers = [
                        Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)))
                    ]
                }
            }
        })
    }
}
