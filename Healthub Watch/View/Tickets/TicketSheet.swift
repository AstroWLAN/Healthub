import SwiftUI
import WatchKit
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct TicketMap : View {
    
    @Binding var ticketRegion : MKCoordinateRegion
    @Binding var markers : [Marker]
    
    
    var body : some View {
        Map(coordinateRegion: $ticketRegion, annotationItems: markers) { marker in
            marker.location
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .disabled(true)
    }
}

struct TicketInformation : View {
    
    @Binding var ticket : Ticket?
    
    var body : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ticket!.title)
                .font(.system(size: 24,weight: .bold))
            Text(ticket!.doctor)
            Text(ticket!.date.formatted(.dateTime.day()) + " " + ticket!.date.formatted(.dateTime.month(.wide)) + " " + ticket!.date.formatted(.dateTime.year()))
            Text(ticket!.date.formatted(.dateTime.hour().minute()))
        }
    }
}

struct TicketSheet: View {
    
    @Binding var selectedTicket : Ticket?
    @Binding var selectedTicketRegion : MKCoordinateRegion
    @Binding var selectedTicketMarkers : [Marker]
    
    var body: some View {
        TabView {
            TicketInformation(ticket: $selectedTicket)
            TicketMap(ticketRegion: $selectedTicketRegion, markers: $selectedTicketMarkers)
        }
    }
}
