import SwiftUI
import MapKit

// FakeTicket data structure
struct Ticket : Hashable {
    let title : String
    let doctor : String
    let date : Date
    let time : Date
    let latitude : Double
    let longitude : Double
}

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct Tickets: View {
    
    @State private var displayTicketDetails : Bool = false
    @State private var selectedTicket : Ticket?
    @State private var selectedTicketRegion : MKCoordinateRegion = MKCoordinateRegion()
    @State private var selectedTicketAddress : String?
    @State private var selectedTicketMarkers : [Marker] = []
    let mapSpan : CLLocationDegrees = 0.01
    
    // List of user tickets
    @State private var userTickets : [Ticket] = [
        Ticket(
            title: "Vaccination", doctor: "Shaun Murphy",
            date: Date(), time: Date(),
            latitude: 45.60087329239974, longitude: 9.260394773730217)
    ]
    
    var body : some View {
        // Display user tickets
        if userTickets.isEmpty {
            VStack(spacing: 8) {
                // Empty list placeholder
                Image("TicketsPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
            }
            .foregroundColor(.gray)
        }
        else {
            // Tickets list
            List {
                ForEach(userTickets, id: \.self) { ticket in
                    Button(
                        action: {
                            displayTicketDetails = true
                            selectedTicket = ticket
                            selectedTicketRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: ticket.latitude, longitude: ticket.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            selectedTicketMarkers = [
                                Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: ticket.latitude, longitude: ticket.longitude)))
                            ]
                            /*
                             Function to generate the ticket textual address
                             */
                            selectedTicketAddress = "Sample Address"
                        },
                        label:  {
                            HStack {
                                Text(ticket.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13,weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                }
            }
            .listStyle(.elliptical)
            .sheet(isPresented: $displayTicketDetails) {
                TicketSheet(
                    ticket: $selectedTicket, ticketRegion: $selectedTicketRegion,
                    ticketAddress: $selectedTicketAddress, ticketMarkers: $selectedTicketMarkers
                )
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(
                            action: {
                                displayTicketDetails = false
                            },
                            label:  {
                                Text("Close")
                                    .foregroundColor(.pink)
                            }
                        )
                    }
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
