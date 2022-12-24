import SwiftUI
import MapKit

struct MapView : View {
    
    @Binding var ticketRegion : MKCoordinateRegion
    @Binding var ticketMarkers : [Marker]
    @Binding var ticketAddress : String?
    
    var body : some View {
        VStack {
            Map(coordinateRegion: $ticketRegion,interactionModes: .zoom,annotationItems: ticketMarkers) { marker in
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
    
    @Binding var ticket : Ticket?
    @Binding var ticketRegion : MKCoordinateRegion
    @Binding var ticketAddress : String?
    @Binding var ticketMarkers : [Marker]
    
    var body: some View {
        TabView {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .padding(10)
                    .foregroundColor(.gray)
                    .opacity(0.2)
                VStack(alignment: .leading, spacing: 8) {
                    Text(ticket!.title)
                        .font(.system(size: 23, weight: .bold))
                    Text(ticket!.doctor)
                    Text(
                        ticket!.date.formatted(.dateTime.day()) + " " +
                        ticket!.date.formatted(.dateTime.month(.wide)) + " " +
                        ticket!.date.formatted(.dateTime.year())
                    )
                    Text(ticket!.date.formatted(.dateTime.hour().minute()))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            }
            MapView(ticketRegion: $ticketRegion, ticketMarkers: $ticketMarkers, ticketAddress: $ticketAddress)
        }
    }
}
