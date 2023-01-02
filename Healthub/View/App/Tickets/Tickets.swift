import SwiftUI
import AlertToast
struct TicketsView: View {
    
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    
    @State private var currentDate : Date = Date()
    @State private var selectedTicket : Reservation?
    @State private var displayTicketDetails : Bool = false
    
    let examGlyphs : [ String : String ] = [ "routine" : "figure.arms.open", "vaccination" : "cross.vial.fill", "sport" : "figure.run",
                                                  "specialist" : "brain.head.profile", "certificate" : "heart.text.square.fill", "other" : "magnifyingglass" ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if ticketViewModel.isLoadingTickets == false {
                
                        // Placeholder for the empty tickets list
                        if ticketViewModel.reservations.isEmpty {
                            Image("TicketsPlaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .padding(.bottom, 80)
                        }
                        
                        // Tickets list
                        else {
                            
                            List {
                                Section(header: Text(String())) {
                                    ForEach(Array(ticketViewModel.reservations.enumerated()), id: \.element) { index,ticket in
                                        
                                        // Display details for the selected ticket
                                        Button(
                                            action: {
                                                selectedTicket = ticket
                                                displayTicketDetails = true
                                            },
                                            label: {
                                                Label(ticket.examinationType.name.capitalized, systemImage: examGlyphs[ticket.examinationType.name] ?? "staroflife.fill")
                                            }
                                        )
                                        .swipeActions {
                                            // Delete action
                                            Button(
                                                role: .destructive,
                                                action: { ticketViewModel.deleteReservation(reservation_id: Int(ticket.id)) },
                                                label: { Image(systemName: "trash.fill") })
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .listRowSeparator(.hidden)
                            }
                            .labelStyle(Cubic())
                            .scrollIndicators(.hidden)
                            .scrollContentBackground(.hidden)
                            .sheet(isPresented: $displayTicketDetails) {
                                TicketSheetView(ticket: $selectedTicket)
                                    .presentationDetents([.large])
                            }
                        }
                    }
                    // Loading placeholder
                    else {
                        ProgressView()
                            .tint(Color(.systemGray))
                    }
                }
            }
            .navigationTitle("Tickets")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(currentDate.formatted(.dateTime.weekday(.wide)).capitalized + " " +
                         currentDate.formatted(.dateTime.day().month(.wide)).capitalized)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color(.systemGray))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: BookingView()) {
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
        }
        .tint(Color(.systemPink))
        .onAppear(
            perform: {
                if(UserDefaults.standard.bool(forKey: "isLogged")) {
                ticketViewModel.connectivityProvider.connect()
                ticketViewModel.fetchTickets()
                }
                
            }
        )
    }
}
