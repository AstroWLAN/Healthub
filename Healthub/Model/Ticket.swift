import Foundation

struct Ticket : Hashable {
    let title : String
    let doctor : String
    let date : Date
    let time : Date
    let ticketLatitude : Double
    let ticketLongitude : Double
}
