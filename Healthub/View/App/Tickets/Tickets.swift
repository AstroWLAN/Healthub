import SwiftUI

struct TicketGalleryView: View {
    
    @State private var currentDate : Date = Date()
    @State private var selectedTicket : Ticket?
    @State private var displayTicketDetails : Bool = false
    @State private var userTickets : [Ticket] = [
        Ticket(title: "Cardioscopy",
               doctor: "Shaun Murphy",
               date: Date(),
               time: Date(),
               ticketLatitude: 45.60085160791855,
               ticketLongitude: 9.260335527083102)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    if userTickets.isEmpty {
                        Image("TicketsPlaceholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                            .padding(.bottom, 60)
                    }
                    else {
                        List {
                            Section(header: Text(String())) {
                                ForEach(Array(userTickets.enumerated()), id: \.element) { index,ticket in
                                    Button(
                                        action: {
                                            selectedTicket = ticket
                                            displayTicketDetails = true
                                        },
                                        label: {
                                            Label(ticket.title, systemImage: "staroflife.fill")
                                        }
                                    )
                                    .swipeActions {
                                        Button(
                                            role: .destructive,
                                            action: { userTickets.remove(at: index) },
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
    }
}

struct TicketGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        TicketGalleryView()
    }
}
