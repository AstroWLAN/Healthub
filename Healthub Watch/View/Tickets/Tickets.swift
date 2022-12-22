import SwiftUI
import MapKit

// Sample ticket structure
struct Ticket : Hashable {
    let title : String
    let doctor : String
    let date : Date
    let time : Date
    let ticketLatitude : Double
    let ticketLongitude : Double
}

struct Tickets: View {
    
    // Tickets array
    @State private var tickets : [Ticket] = [
        Ticket(title: "Vaccination", doctor: "Shaun Murphy", date: Date(), time: Date(),
               ticketLatitude: 45.60087329239974, ticketLongitude: 9.260394773730217)
    ]
    
    @State private var displayTicketSheet : Bool = false
    @State private var selectedTicket : Ticket?
    @State private var selectedTicketRegion : MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.33478879942501, longitude: -122.00892908690875),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var selectedTicketMarkers : [Marker] = []
    
    var body: some View {
        List {
            ForEach( tickets, id: \.self ) { ticket in
                Button(
                    action: {
                        selectedTicket = ticket
                        selectedTicketRegion = MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: ticket.ticketLatitude, longitude: ticket.ticketLongitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        selectedTicketMarkers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: ticket.ticketLatitude, longitude:ticket.ticketLongitude), tint: .red))]
                        displayTicketSheet = true
                    },
                    label:  {
                        HStack {
                            Text(ticket.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                )
            }
        }
        .listStyle(.elliptical)
        .sheet(isPresented: $displayTicketSheet) {
            TicketSheet(selectedTicket: $selectedTicket,
                        selectedTicketRegion: $selectedTicketRegion, selectedTicketMarkers: $selectedTicketMarkers)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { displayTicketSheet = false }
                            .foregroundColor(Color.pink)
                    }
                }
        }
    }
}

struct Tickets_Previews: PreviewProvider {
    static var previews: some View {
        Tickets()
    }
}
