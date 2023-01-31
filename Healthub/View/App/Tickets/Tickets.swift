import SwiftUI
import SPIndicator

struct TicketsView: View {
    
    @EnvironmentObject private var ticketViewModel: TicketViewModel
    
    @State private var currentDate : Date = Date()
    @State private var selectedTicket : Reservation?
    @State private var displayTicketDetails : Bool = false
    
    @State private var confirmedBooking : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea()
                // TICKETS
                VStack(spacing: 0) {
                    if ticketViewModel.isLoadingTickets == false {
                        // Empty list placeholder
                        if ticketViewModel.reservations.isEmpty {
                            VStack(spacing: 0) {
                                Image("TicketsPlaceholder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 160)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 40))
                                    .accessibilityIdentifier("TicketsPlaceholder")
                                Capsule()
                                    .frame(width: 80, height: 30)
                                    .foregroundColor(Color(.systemGray5))
                                    .overlay(
                                        Text("Empty")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(Color(.systemGray))
                                    )
                            }
                            .padding(.bottom, 40)
                        }
                        // Tickets list
                        else {
                            List {
                                Section(header: Text("Reservations")) {
                                    ForEach(Array(ticketViewModel.reservations.enumerated()), id: \.element) { index,ticket in
                                        // Shows details of the selected ticket
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
                                                label: { Image(systemName: "trash.fill") }
                                            )
                                            .accessibilityIdentifier("TicketDeleteButton")
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .listRowSeparator(.hidden)
                            }
                            .accessibilityIdentifier("TicketsList")
                            .refreshable(action: { ticketViewModel.fetchTickets(force_reload: false) })
                            .labelStyle(Cubic())
                            .scrollIndicators(.hidden)
                            .scrollContentBackground(.hidden)
                            .sheet(isPresented: $displayTicketDetails) {
                                TicketSheetView(ticket: $selectedTicket)
                                    .presentationDetents([.large])
                            }
                        }
                    }
                    // Loading data placeholder
                    else {
                        VStack(spacing:0){
                            Spacer()
                            VStack(spacing:0) {
                                ProgressView().progressViewStyle(.circular)
                                    .padding(.bottom, 10)
                                    .tint(Color(.systemGray))
                                Text("Loading Tickets")
                                    .foregroundColor(Color(.systemGray))
                                    .font(.system(size: 17, weight: .medium))
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Tickets")
            .toolbar{
                // Current date
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(currentDate.formatted(.dateTime.day().month(.wide)).capitalized + " " + currentDate.formatted(.dateTime.year()))
                        .accessibilityIdentifier("CurrentDate")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(.systemGray))
                }
                // Booking ticket button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: BookingView(bookingSuccess: $confirmedBooking)) {
                        ZStack {
                            Circle()
                                .frame(height: 28)
                                .opacity(0.2)
                            Image(systemName: "plus")
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                    .accessibilityIdentifier("BookingButton")
                }
            }
        }
        .tint(Color("AstroRed"))
        .onAppear( perform: { if(UserDefaults.standard.bool(forKey: "isLogged")) { ticketViewModel.connectivityProvider.connect() }})
        .onChange(of: confirmedBooking, perform: {_ in
            confirmedBooking = false
        })
        .SPIndicator(
            isPresent: $confirmedBooking,
            title: "Success",
            message: "Ticket Created",
            duration: 1.5,
            presentSide: .top,
            dismissByDrag: false,
            preset: .custom(UIImage(systemName: "checkmark.circle.fill")!.withTintColor(UIColor(Color(.systemGreen)), renderingMode: .alwaysOriginal)),
            haptic: .success,
            layout: .init(iconSize: CGSize(width: 26, height: 26), margins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)))
    }
}
