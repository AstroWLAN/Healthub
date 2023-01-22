import SwiftUI
import AlertToast
struct TicketsView: View {
    
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    
    @State private var currentDate : Date = Date()
    @State private var selectedTicket : Reservation?
    @State private var displayTicketDetails : Bool = false
    
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
                                                HStack {
                                                    Label(ticket.examinationType.name.capitalized, systemImage: ExamGlyph().generateGlyph(name: ticket.examinationType.name))
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .foregroundColor(Color(.systemGray4))
                                                }
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
                            .refreshable{
                                // Refresh tickets list
                                ticketViewModel.fetchTickets(force_reload: true)
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
                    Text(currentDate.formatted(.dateTime.day().month(.wide)).capitalized + " " + currentDate.formatted(.dateTime.year()))
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
        .tint(Color("AstroRed"))
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
