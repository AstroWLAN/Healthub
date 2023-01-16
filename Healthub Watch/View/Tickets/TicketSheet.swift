import SwiftUI
import MapKit

struct MapView : View {
    
    @Binding var ticketRegion : MKCoordinateRegion
    @Binding var ticketMarkers : [Marker]
    @Binding var ticketAddress : String?
    
    var body : some View {
        VStack {
            Map(coordinateRegion: $ticketRegion, interactionModes: .zoom,annotationItems: ticketMarkers) { marker in
                marker.location
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.vertical, 10)
            Text(ticketAddress!)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.2)
    }
}

struct TicketSheet: View {
    
    @Binding var ticket : Reservation?
    @State var ticketRegion : MKCoordinateRegion = MKCoordinateRegion()
    @Binding var ticketAddress : String?
    @State var ticketMarkers : [Marker] = []
    
 
    
    var body: some View {
        TabView {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .padding(10)
                    .foregroundColor(.gray)
                    .opacity(0.2)
                VStack(alignment: .leading, spacing: 8) {
                    Text(ticket!.examinationType.name)
                        .font(.system(size: 23, weight: .bold))
                    Text(ticket!.doctor.name!)
                    Text(
                        ticket!.date.formatted(.dateTime.day()) + " " +
                        ticket!.date.formatted(.dateTime.month(.wide)) + " " +
                        ticket!.date.formatted(.dateTime.year())
                    )
                    Text(ticket!.time.formatted(.dateTime.hour().minute()))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            }
            if ticketMarkers.isEmpty == false{
                MapView(ticketRegion: $ticketRegion, ticketMarkers: $ticketMarkers, ticketAddress: $ticketAddress)
            }else{
                Text("nothing to show")
            }
        
        }.onAppear(perform:{
            Address2Coordinates.translate(from: ticketAddress!){(location, error) in
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
