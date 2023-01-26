import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct Tickets: View {
    
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    @State private var displayTicketDetails : Bool = false
    @State private var selectedTicket : Reservation?
    @State private var selectedTicketRegion : MKCoordinateRegion = MKCoordinateRegion()
    @State private var selectedTicketAddress : String?
    @State private var selectedTicketMarkers : [Marker] = []
    @State var ticketLatitude: CLLocationDegrees = CLLocationDegrees()
    @State var ticketLongitude: CLLocationDegrees = CLLocationDegrees()
    let mapSpan : CLLocationDegrees = 0.01
    
    // USER TICKETS
    var body : some View {
        Group {
            // Empty list placeholder
            if ticketViewModel.connectivityProvider.received.isEmpty {
                VStack(spacing: 0) {
                    Image("TicketsPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .opacity(0.5)
                        .padding(.vertical, 20)
                    Capsule()
                        .frame(width: 80, height: 30)
                        .foregroundColor(Color("AstroGray"))
                        .overlay(
                            Text("Empty")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(.lightGray))
                        )
                }
            }
            else {
                List {
                    // Header
                    HStack {
                        Text("Tickets")
                            .foregroundColor(Color(.white))
                        Spacer()
                        HStack(spacing: 0) {
                            Image(systemName: "barcode")
                                .padding(.trailing, -10)
                            Image(systemName: "barcode")
                        }
                    }
                    .font(.system(size: 24, weight: .heavy))
                    .listItemTint(.clear)
                    // Tickets
                    ForEach(ticketViewModel.connectivityProvider.received, id: \.self) { ticket in
                        Button(
                            action: {
                                displayTicketDetails = true
                                selectedTicket = ticket
                                selectedTicketAddress = ticket.doctor.address
                            },
                            label:  {
                                HStack {
                                    Text(ticket.examinationType.name.capitalized)
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
                .onAppear(perform: { ticketViewModel.connectivityProvider.connect() })
                .sheet(isPresented: $displayTicketDetails) {
                    TicketSheet(ticket: $selectedTicket, ticketAddress: $selectedTicketAddress)
                    .toolbar {
                        // Customised CLOSE button
                        ToolbarItem(placement: .cancellationAction) {
                            Button(
                                action: { displayTicketDetails = false },
                                label:  {
                                    Text("Close")
                                        .foregroundColor(Color("AstroRed"))
                                }
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("Hub")
    }
}
