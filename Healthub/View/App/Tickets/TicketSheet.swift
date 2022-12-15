import SwiftUI
import MapKit
import AlertToast

struct TicketSheetView: View {
    
    @Binding var ticket : Reservation?
    @State var ticketLatitude : CLLocationDegrees?
    @State var ticketLongitude : CLLocationDegrees?
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Capsule()
                        .frame(width: 30, height: 6)
                        .foregroundColor(Color(.systemGray5))
                        .padding(.top,20)
                    Spacer()
                }
                HStack(spacing: 0) {
                    Text("Ticket")
                        .font(.largeTitle.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                    Spacer()
                    Group {
                        Image(systemName: "barcode")
                            .padding(.trailing, -10)
                        Image(systemName: "barcode")
                    }
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(.systemGray4))
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                List {
                    Section(header: Text("Generalities"))  {
                        Label(ticket!.examinationType.name, systemImage: "staroflife.fill")
                        Label(ticket!.doctor.name, systemImage: "stethoscope")
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
                    if (ticketLatitude != nil && ticketLongitude != nil){
                            AddressView(location: CLLocationCoordinate2D(latitude: ticketLatitude!, longitude: ticketLongitude!))
                                .frame(height: 120)
                                .scaledToFit()
                        }else{
                            AlertToast(type: .loading, title: "Loading")
                        }
                            
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .labelStyle(Cubic())
                .scrollContentBackground(.hidden)
            }.task({Address2Coordinates.translate(from: ticket!.doctor.address){(location, error) in
                if let location = location{
                    self.ticketLatitude = location.latitude
                    self.ticketLongitude = location.longitude
                }
            }
            })
        }
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
            }
            else {
                ZStack{
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(Color(.systemGray6))
                    HStack {
                        Spacer()
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                            .tint(Color(.systemGray))
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
            generateMapSnapshot()
        }
    }
    
    // Generates the map snapshot
    func generateMapSnapshot() {
        if let cachedVersion = cache.object(forKey: "\(location.latitude), \(location.longitude)" as NSString ) {
            self.mapSnapshotImage = cachedVersion
        } else {
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
