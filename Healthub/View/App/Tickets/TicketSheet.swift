import SwiftUI
import MapKit
import AlertToast

struct TicketSheetView: View {
    
    @Binding var ticket : Reservation?
    @State var ticketLatitude : CLLocationDegrees?
    @State var ticketLongitude : CLLocationDegrees?
    
    var body: some View {
        ZStack {
            
            // Background color
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Drag indicator
                HStack {
                    Spacer()
                    Capsule()
                        .frame(width: 30, height: 6)
                        .foregroundColor(Color(.systemGray5))
                        .padding(.top,20)
                    Spacer()
                }
                // Header
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text("Ticket")
                        .font(.largeTitle.bold())
                        .minimumScaleFactor(0.2)
                    Spacer()
                    VStack(spacing : 0) {
                        Text(generateFakeCode())
                            .font(.system(size: 10, weight: .bold))
                        HStack(spacing: 0) {
                            Image(systemName: "barcode")
                                .padding(.trailing, -10)
                            Image(systemName: "barcode")
                        }
                        .font(.system(size: 34, weight: .bold))
                    }
                    .foregroundColor(Color(.systemGray4))
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                
                // Details
                List {
                    
                    // Generalities
                    Section(header: Text("Generalities"))  {
                        Label(ticket!.examinationType.name.capitalized, systemImage: "staroflife.fill")
                            .labelStyle(Cubic(glyphBackgroundColor: Color(.systemPink)))
                        Label(ticket!.doctor.name!.capitalized, systemImage: "stethoscope")
                            .labelStyle(Cubic())
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    
                    // Date and Time
                    Section(header: Text("Time")) {
                        Label(ticket!.date.formatted(.dateTime.day().month(.wide)).capitalized + " " + ticket!.date.formatted(.dateTime.year()),
                              systemImage: "calendar")
                        Label(String(ticket!.time.formatted(.dateTime.hour().minute())), systemImage: "timer")
                    }
                    .labelStyle(Cubic())
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    
                    // Address map
                    Section(header: Text("Address")) {
                        if (ticketLatitude != nil && ticketLongitude != nil) {
                            AddressView(location: CLLocationCoordinate2D(latitude: ticketLatitude!, longitude: ticketLongitude!))
                        }
                        else {
                            // Map placeholder
                        }
                    }
                    .labelStyle(Cubic())
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .scrollContentBackground(.hidden)
            }
            // Translates a string address into logitude and latitude coordinates
            .task(
                { Address2Coordinates.translate(from: ticket!.doctor.address!)
                    {(location, error) in
                        if let location = location {
                            self.ticketLatitude = location.latitude
                            self.ticketLongitude = location.longitude
                        }
                    }
                }
            )
        }
    }
    
    // Generates an alphanumeric code for UI purposes
    func generateFakeCode() -> String {
        let symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{ _ in symbols.randomElement()! })
    }
    
}

struct AddressView: View {
    
    let location: CLLocationCoordinate2D
    let span: CLLocationDegrees = 0.01
    let cache = NSCache<NSString, UIImage>()
    
    @State private var mapSnapshotImage: UIImage?
    
    var body: some View {
        Group {
            if let mapImage = mapSnapshotImage {
                Image(uiImage: mapImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    // Gets directions in the map app for the specified address
                    .onTapGesture {
                        let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)")
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }
            }
            else {
                // Map loading placeholder
                HStack {
                    Spacer()
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                        .tint(Color(.systemGray))
                    Spacer()
                }
                .frame(width: 400)
            }
        }
        .frame(height: 120)
        .scaledToFit()
        .onAppear {
            generateMapSnapshot()
        }
    }
    
    // Generates a map snapshot for the given address
    func generateMapSnapshot() {
        
        // Cached version of the map
        if let cachedVersion = cache.object(forKey: "\(location.latitude), \(location.longitude)" as NSString ) {
            self.mapSnapshotImage = cachedVersion
        }
        // Generates the snapshot
        else {
            let mapOptions = MKMapSnapshotter.Options()
            mapOptions.region = MKCoordinateRegion( center: self.location, span: MKCoordinateSpan( latitudeDelta: self.span, longitudeDelta: self.span ))
            mapOptions.size = CGSize(width: 400, height: 140)
            mapOptions.mapType = .standard
            mapOptions.showsBuildings = true
            
            MKMapSnapshotter(options: mapOptions).start { (mapSnapshot, mapError) in
                if let error = mapError {
                    print(error)
                    return
                }
                if let snapshot = mapSnapshot {
                    self.mapSnapshotImage = snapshot.image
                    cache.setObject(snapshot.image, forKey: "\(self.location.latitude), \(self.location.longitude)" as NSString)
                }
            }
        }
    }
}
