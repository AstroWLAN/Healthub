import SwiftUI
import MapKit


struct TicketSheetView: View {
    
    @Binding var ticket : Ticket?
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("Details")
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 0))
                List {
                    Section {
                        Label(ticket!.title, systemImage: "staroflife.fill")
                        Label(ticket!.doctor, systemImage: "stethoscope")
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    Section(header: Text("Date")) {
                        Label(ticket!.date.formatted(.dateTime.day().month(.wide)) + " " + ticket!.date.formatted(.dateTime.year()),
                              systemImage: "calendar")
                        Label(ticket!.date.formatted(.dateTime.hour().minute()), systemImage: "timer")
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    Section(header: Text("Address")) {
                        AddressView(location: CLLocationCoordinate2D(latitude: ticket!.ticketLatitude, longitude: ticket!.ticketLongitude))
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .labelStyle(Cubic())
                .scrollContentBackground(.hidden)
            }
        }
    }
    
}

struct AddressView: View {
    
    let location: CLLocationCoordinate2D
    var span: CLLocationDegrees = 0.01
    let cache = NSCache<NSString, UIImage>()
    
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
                        .frame(width: 336, height: 120)
                    HStack {
                        Spacer()
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
            }
        }
        .onTapGesture {
            let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
        .onAppear {
            if let cachedVersion = cache.object(forKey: "\(location.latitude), \(location.longitude)" as NSString ) {
                // use the cached version
                self.mapSnapshotImage = cachedVersion
            } else {
                // create it from scratch then store in the cache
                generateMapSnapshot()
            }
        }
    }
    
    // Generates the map snapshot
    func generateMapSnapshot() {
        /// ** Map Options **
        let mapOptions = MKMapSnapshotter.Options()
        // Describes the displayed region
        mapOptions.region = MKCoordinateRegion( center: self.location, span: MKCoordinateSpan( latitudeDelta: self.span, longitudeDelta: self.span ))
        // Describes the size of the map
        mapOptions.size = CGSize(width: 336, height: 120)
        mapOptions.mapType = .standard
        mapOptions.showsBuildings = true
        
        // Generates the Map Snapshot
        MKMapSnapshotter(options: mapOptions).start { (snapshotOrNil, errorOrNil) in
            if let error = errorOrNil {
                print(error)
                return
            }
            if let snapshot = snapshotOrNil {
                self.mapSnapshotImage = snapshot.image
                print("\(self.location.latitude), \(self.location.longitude)" as NSString)
                cache.setObject(snapshot.image, forKey: "\(self.location.latitude), \(self.location.longitude)" as NSString)
            }
        }
    }
}
