import SwiftUI
import AlertToast
struct TicketsView: View {
    
    @State private var currentDate : Date = Date()
    @State private var selectedTicket : Reservation?
    @State private var displayTicketDetails : Bool = false
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    
    // Sample Exams
    /*@State private var userTickets : [Ticket] = [
        Ticket(title: "Cardioscopy",
               doctor: "Shaun Murphy",
               date: Date(),
               time: Date(),
               ticketLatitude: 45.60085160791855,
               ticketLongitude: 9.260335527083102),
        Ticket(title: "Vaccination",
               doctor: "Gregory House",
               date: Date(),
               time: Date(),
               ticketLatitude: 37.254226245713866,
               ticketLongitude: -121.94670027234936)
    ]*/
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    if ticketViewModel.isLoadingTickets == false{
                        if ticketViewModel.reservations.isEmpty {
                            Image("TicketsPlaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .padding(.bottom, 80)
                        }
                        else {
                            List {
                                Section(header: Text(String())) {
                                    ForEach(Array(ticketViewModel.reservations.enumerated()), id: \.element) { index,ticket in
                                        Button(
                                            action: {
                                                selectedTicket = ticket
                                                displayTicketDetails = true
                                            },
                                            label: {
                                                Label(ticket.examinationType.name, systemImage: "staroflife.fill")
                                            }
                                        )
                                        .swipeActions {
                                            Button(
                                                role: .destructive,
                                                action: { ticketViewModel.deleteReservation(reservation_id: ticket.id) },
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
                    }else{
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Tickets")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(currentDate.formatted(.dateTime.weekday(.wide)).capitalized + " " +
                         currentDate.formatted(.dateTime.day().month(.wide)))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color(.systemGray))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: BookingView()) {
                        ZStack {
                            Circle()
                                .frame(height: 28)
                                .opacity(0.2)
                            Image(systemName: "calendar")
                                .font(.system(size: 13, weight: .medium))
                        }
                    }
                }
            }
        }
        .tint(Color(.systemPink))
        .onAppear(perform: {
            if(UserDefaults.standard.bool(forKey: "isLogged")){
                ticketViewModel.fetchTickets()
            }
            
            ticketViewModel.connectivityProvider.connect()
            //ticketViewModel.connectivityProvider.sendWatchMessage()
        })
        
    }
}

struct TicketGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsView()
    }
}
