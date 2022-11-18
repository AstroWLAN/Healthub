import SwiftUI
import MapKit

// Navigation bar inspired by the Apple App Store
struct AppNavigationBar : View {
    
    @State private var currentDate : Date = Date()
    
    var body : some View {
        VStack{
            HStack{
                Text("\(currentDate.formatted(.dateTime.weekday(.wide)).capitalized)" +
                     " \(currentDate.formatted(.dateTime.day()))" +
                     " \(currentDate.formatted(.dateTime.month(.wide)).capitalized)")
                .font(.system(size: 17,weight: .medium))
                .foregroundColor(Color(.systemGray2))
                Spacer()
                
            }
            HStack{
                Text("Schedule")
                    .bold()
                    .font(.largeTitle.bold())
                Spacer()
                NavigationLink(destination: BookingView()) {
                    Image(systemName: "plus").font(.title2)
                }
            }
        }
        .padding()
    }
}

// Creates a custom card shape
struct CardShape : View {
    
    var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 280,height: 380)
                .foregroundColor(.white)
            Circle().frame(width: 60)
                .offset(y: -195)
                .blendMode(.destinationOut)
        }
        .compositingGroup()
        .shadow(color: Color(.systemGray5), radius: 8)
    }
    
}

// Creates a map snapshot
struct MapSnapshotView: View {
    
    let location: CLLocationCoordinate2D
    var span: CLLocationDegrees = 0.01
    
    @State private var mapSnapshotImage: UIImage? = nil
    
    var body: some View {
        Group {

            if let mapImage = mapSnapshotImage {
                Image(uiImage: mapImage)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            else {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .frame(width: 230, height: 120)
                    HStack {
                        Spacer()
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            generateMapSnapshot()
        }
    }
    
    func generateMapSnapshot() {
        
        /// ** Map Options **
        let mapOptions = MKMapSnapshotter.Options()
        // Describes the displayed region
        mapOptions.region = MKCoordinateRegion( center: self.location, span: MKCoordinateSpan( latitudeDelta: self.span, longitudeDelta: self.span ))
        // Describes the size of the map
        mapOptions.size = CGSize(width: 230, height: 120)
        mapOptions.mapType = .standard
        mapOptions.showsBuildings = true
        
        /// ** Generates the Map Snapshot **
        MKMapSnapshotter(options: mapOptions).start { (snapshotOrNil, errorOrNil) in
            if let error = errorOrNil {
                print(error)
                return
            }
            if let snapshot = snapshotOrNil {
                self.mapSnapshotImage = snapshot.image
            }
        }
    }
}

struct TicketView : View {
    
    @Binding var ticketCounter : Int
    @State var ticketTitle : String
    @State var ticketDoctor : String
    @State var ticketDate : Date
    @State var ticketTime : Date
    @State var ticketAddress : CLLocationCoordinate2D
    
    var body : some View {
        
        ZStack(alignment: .center){
            CardShape()
            VStack(alignment: .leading){
                Text(ticketTitle)
                    .font(.title.bold())
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                Text(ticketDoctor)
                    .font(.system(size: 17,weight: .medium))
                    .foregroundColor(Color(.systemGray))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Text(ticketDate.formatted(.dateTime.day().month(.wide).year()))
                    .font(.system(size: 17,weight: .medium))
                    .foregroundColor(Color(.systemGray))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Text(ticketTime.formatted(.dateTime.hour().minute()))
                    .font(.system(size: 17,weight: .medium))
                    .foregroundColor(Color(.systemGray))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                MapSnapshotView(location: ticketAddress)
                HStack(alignment: .firstTextBaseline){
                    Spacer()
                    Circle().frame(width: 8).foregroundColor(Color(.systemGray6))
                    Circle().frame(width: 8).foregroundColor(Color(.systemGray6))
                    Circle().frame(width: 8).foregroundColor(Color(.systemGray6))
                    Text("Ticket N° : \(ticketCounter)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(.systemGray4))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    Circle().frame(width: 8).foregroundColor(Color(.systemGray6))
                    Circle().frame(width: 8).foregroundColor(Color(.systemGray6))
                    Circle().frame(width: 8).foregroundColor(Color(.systemGray6))
                    Spacer()
                }
                
            }
            .frame(width: 230,height: 370)
            .scaledToFill()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
    }
}

struct Ticket : Identifiable {
    let id : UUID = UUID()
    let name : String
    let doctor : String
    let date : Date
    let time : Date
    let address : CLLocationCoordinate2D
}

struct ScheduleView: View {
    
    @State private var tickets : [Ticket] = [
        Ticket(name: "Cardioscopy", doctor: "Dr. Shaun Murphy", date: Date(), time: Date(), address: CLLocationCoordinate2D(latitude: 45.60086364085512, longitude: 9.260684505618796)),
        Ticket(name: "Vaccination", doctor: "Dr. Aaron Glassman", date: Date(), time: Date(), address: CLLocationCoordinate2D(latitude: 45.6085934580059, longitude: 9.356561808400514)),
        Ticket(name: "Pap Test", doctor: "Dr.ssa Audrie Lim", date: Date(), time: Date(), address: CLLocationCoordinate2D(latitude: 45.585279554967606, longitude: 9.302992975560533)),
        Ticket(name: "Spirometry", doctor: "Dr. Gregory House", date: Date(), time: Date(), address: CLLocationCoordinate2D(latitude: 45.57802442816259, longitude: 9.306659096930387))
    ]
    @State private var ticketCounter : Int = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                AppNavigationBar()
                Spacer()
                ScrollView(.horizontal){
                    LazyHGrid(rows: [GridItem()],spacing: 20){
                        ForEach(tickets){ ticket in
                            TicketView(ticketCounter: $ticketCounter,
                                       ticketTitle: ticket.name,
                                       ticketDoctor: ticket.doctor,
                                       ticketDate: ticket.date, ticketTime: ticket.time,
                                       ticketAddress: ticket.address)
                        }
                    }
                    .padding(.leading,20)
                    .frame(height: 420)
                }
                .scrollIndicators(.hidden)
                Spacer()
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }

}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
