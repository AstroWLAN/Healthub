import SwiftUI
import MapKit

// FakeTicket data structure
/*struct Ticket : Hashable {
    let title : String
    let doctor : String
    let date : Date
    let time : Date
    let latitude : Double
    let longitude : Double
}*/

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct Tickets: View {
    
    @State private var displayTicketDetails : Bool = false
    @State private var selectedTicket : Reservation?
    @State private var selectedTicketRegion : MKCoordinateRegion = MKCoordinateRegion()
    @State private var selectedTicketAddress : String?
    @State private var selectedTicketMarkers : [Marker] = []
    @State var ticketLatitude: CLLocationDegrees = CLLocationDegrees()
    @State var ticketLongitude: CLLocationDegrees = CLLocationDegrees()
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    let mapSpan : CLLocationDegrees = 0.01
    
    // List of user tickets
    
    var body : some View {
        // Display user tickets
        if ticketViewModel.connectivityProvider.received.isEmpty {
            Image("TicketsPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 140)
                .opacity(0.7)
        }
        else {
            // Tickets list
            List {
                ForEach(ticketViewModel.connectivityProvider.received, id: \.self) { ticket in
                    Button(
                        action: {
                            displayTicketDetails = true
                            selectedTicket = ticket
                            /*
                             Function to generate the ticket textual address
                             */
                            selectedTicketAddress = ticket.doctor.address
                        },
                        label:  {
                            HStack {
                                Text(ticket.examinationType.name)
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
            .onAppear(perform: {
                ticketViewModel.connectivityProvider.connect()
            })
            .sheet(isPresented: $displayTicketDetails) {
                TicketSheet(ticket: $selectedTicket, ticketAddress: $selectedTicketAddress
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
