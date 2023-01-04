import SwiftUI

struct WatchMain: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: Tickets()) {
                    VStack(alignment: .leading) {
                        ZStack {
                            Circle().frame(width: 48)
                                .foregroundColor(Color.pink)
                            Image(systemName: "ticket.fill")
                                .font(.system(size: 24,weight: .bold))
                        }
                        Text("Tickets")
                            .font(.system(size: 20,weight: .bold))
                        Text("Booked Examinations")
                            .font(.system(size: 15,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 10)
                }
                NavigationLink(destination: Therapies()) {
                    VStack(alignment: .leading) {
                        ZStack {
                            Circle().frame(width: 48)
                                .foregroundColor(Color.pink)
                            Image(systemName: "pills.fill")
                                .font(.system(size: 24,weight: .bold))
                        }
                        Text("Therapies")
                            .font(.system(size: 20,weight: .bold))
                        Text("Personal Prescriptions")
                            .font(.system(size: 15,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 10)
                }
                NavigationLink(destination: Pathologies()) {
                    VStack(alignment: .leading) {
                        ZStack {
                            Circle().frame(width: 48)
                                .foregroundColor(Color.pink)
                            Image(systemName: "allergens.fill")
                                .font(.system(size: 22,weight: .bold))
                        }
                        Text("Pathologies")
                            .font(.system(size: 20,weight: .bold))
                        Text("User Illnesses")
                            .font(.system(size: 15,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 10)
                }
                NavigationLink(destination: Doctors()) {
                    VStack(alignment: .leading) {
                        ZStack {
                            Circle().frame(width: 48)
                                .foregroundColor(Color.pink)
                            Image(systemName: "stethoscope")
                                .font(.system(size: 22,weight: .bold))
                        }
                        Text("Doctors")
                            .font(.system(size: 20,weight: .bold))
                        Text("Doctors Information")
                            .font(.system(size: 15,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 10)
                }
                NavigationLink(destination: Profile()) {
                    VStack(alignment: .leading) {
                        ZStack {
                            Circle().frame(width: 48)
                                .foregroundColor(Color.pink)
                            Image(systemName: "figure.arms.open")
                                .font(.system(size: 24,weight: .bold))
                        }
                        Text("Profile")
                            .font(.system(size: 20,weight: .bold))
                        Text("Medical Records")
                            .font(.system(size: 15,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 10)
                }
            }
            .listStyle(.carousel)
        }
    }
}

struct WatchMain_Preview: PreviewProvider {
    static var previews: some View {
        WatchMain()
    }
}
