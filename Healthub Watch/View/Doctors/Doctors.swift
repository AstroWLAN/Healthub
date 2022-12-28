import SwiftUI

/*struct Doctor: Hashable {
    let name: String
    let address: String
}*/


struct Doctors: View {
    
    @State private var userDoctors : [Doctor] = [
        //Doctor(id: 0, name: "Shaun Murphy", address: "Via Della Spiga, 97"),
       // Doctor(id: 1, name: "Gregory House", address: "Via Vicodin, 69")
    ]
    
    var body: some View {
        List {
            if userDoctors.isEmpty {
                // Doctors Placeholder
            }
            else {
                ForEach(userDoctors, id: \.self) { doctor in
                    VStack(alignment: .leading) {
                        Text(doctor.name!)
                            .font(.system(size: 17, weight: .semibold))
                        Text(doctor.address!)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .listStyle(.elliptical)
        .lineLimit(1)
        .minimumScaleFactor(0.2)
    }
}

struct Doctors_Previews: PreviewProvider {
    static var previews: some View {
        Doctors()
    }
}
