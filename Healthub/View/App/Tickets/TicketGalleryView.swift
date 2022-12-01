import SwiftUI
import MapKit

// Custom navigation bar
struct AppNavigationBar : View {
    
    @State var currentDate : Date?
    let viewTitle : String
    let actionGlyph : String
    let destinationView : AnyView
    
    var body : some View {
        VStack{
            HStack{
                if currentDate != nil{
                    Text("\(currentDate!.formatted(.dateTime.weekday(.wide)).capitalized)" +
                         " \(currentDate!.formatted(.dateTime.day()))" +
                         " \(currentDate!.formatted(.dateTime.month(.wide)).capitalized)")
                }
                else {
                    Text(" ")
                }
                Spacer()
            }
            .font(.system(size: 17,weight: .medium))
            .foregroundColor(Color(.systemGray2))
            HStack(alignment: .lastTextBaseline){
                Text(viewTitle)
                    .font(.largeTitle.bold())
                Spacer()
                NavigationLink(destination: destinationView) {
                    Image(systemName: actionGlyph)
                        .font(.title2)
                }
            }
        }
        .padding()
    }
}

// Data Model
struct Ticket : Hashable,Identifiable{
    let id : UUID = UUID()
    let name : String
    let doctor : String
    let date : Date
    let time : Date
    // These values are Doubles
    let addressLatitude : CLLocationDegrees
    let addressLongitude : CLLocationDegrees
}

struct TicketGalleryView: View {
    
    @State private var currentIndex : Int = 0
    @State var offset: CGFloat = 0
    
    // Examples
    @State var userTickets: [Ticket] = [
        Ticket(name: "Cardioscopy", doctor: "Shaun Murphy", date: Date(), time: Date(),
               addressLatitude: 45.60086364085512, addressLongitude: 9.260684505618796),
        Ticket(name: "Vaccination", doctor: "Audrie Lim", date: Date(), time: Date(),
               addressLatitude: 45.6085934580059, addressLongitude: 9.356561808400514),
        Ticket(name: "Spirometry", doctor: "Morgan Reznick", date: Date(), time: Date(),
               addressLatitude: 45.585279554967606, addressLongitude: 9.302992975560533),
        Ticket(name: "Allergens Test", doctor: "Aaron Glassman", date: Date(), time: Date(),
               addressLatitude: 45.57802442816259, addressLongitude: 9.306659096930387)
    ]
    
    var body: some View {
        NavigationStack{
            VStack{
                AppNavigationBar(currentDate: Date(),viewTitle: "Tickets", actionGlyph: "calendar",
                                 destinationView: AnyView(TicketCreationView()))
                Spacer()
                if userTickets.isEmpty {
                    VStack{
                        Image("TicketsPlaceholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                        Text("No Appointments")
                            .font(.system(size: 17,weight: .medium))
                            .foregroundColor(Color(.systemGray5))
                            .padding(.vertical,10)
                    }
                }
                else {
                    VStack{
                        TabView(selection: $currentIndex){
                            ForEach(Array(userTickets.enumerated()), id: \.element){ index,element in
                                TicketView(ticketNumber: index+1, ticketName: element.name, ticketDoctor: element.doctor,
                                           ticketLatitude: element.addressLatitude, ticketLongitude: element.addressLongitude)
                                .tag(index)
                                .contextMenu{
                                    Button(role: .destructive,
                                           action: { userTickets.remove(at: index) },
                                           label: { Label("Remove", systemImage: "trash.fill")})
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 460)
                        Spacer()
                    }
                }
                Spacer()
            }
            .tint(Color(.systemPink))
        }
    }
}

struct TicketGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        TicketGalleryView()
    }
}
