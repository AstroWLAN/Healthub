import SwiftUI

struct WatchMain: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: Tickets()) {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Circle().frame(width: 42)
                                .foregroundColor(Color("AstroRed"))
                            Image(systemName: "ticket.fill")
                                .font(.system(size: 21,weight: .bold))
                        }
                        .padding(.bottom, 8)
                        Text("Tickets")
                            .font(.system(size: 21,weight: .bold))
                        Text("Booked Examinations")
                            .font(.system(size: 13,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(EdgeInsets(top: 12, leading: 6, bottom: 12, trailing: 0))
                }
                .listItemTint(Color("AstroGray"))
               NavigationLink(destination: Therapies()) {
                   VStack(alignment: .leading, spacing: 0) {
                       ZStack {
                           Circle().frame(width: 42)
                               .foregroundColor(Color("AstroRed"))
                           Image(systemName: "pills.fill")
                               .font(.system(size: 21,weight: .bold))
                       }
                       .padding(.bottom, 8)
                       Text("Therapies")
                           .font(.system(size: 21,weight: .bold))
                       Text("Personal Prescriptions")
                           .font(.system(size: 13,weight: .regular))
                           .foregroundColor(Color.gray)
                   }
                   .padding(EdgeInsets(top: 12, leading: 6, bottom: 12, trailing: 0))
                }
                .listItemTint(Color("AstroGray"))
                NavigationLink(destination: Pathologies()) {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Circle().frame(width: 42)
                                .foregroundColor(Color("AstroRed"))
                            Image(systemName: "allergens.fill")
                                .font(.system(size: 21,weight: .bold))
                        }
                        .padding(.bottom, 8)
                        Text("Pathologies")
                            .font(.system(size: 21,weight: .bold))
                        Text("Personal Diseases")
                            .font(.system(size: 13,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(EdgeInsets(top: 12, leading: 6, bottom: 12, trailing: 0))
                }
                .listItemTint(Color("AstroGray"))
                NavigationLink(destination: Doctors()) {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Circle().frame(width: 42)
                                .foregroundColor(Color("AstroRed"))
                            Image(systemName: "person.fill")
                                .font(.system(size: 21,weight: .bold))
                        }
                        .padding(.bottom, 8)
                        Text("Contacts")
                            .font(.system(size: 21,weight: .bold))
                        Text("Doctors Information")
                            .font(.system(size: 13,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(EdgeInsets(top: 12, leading: 6, bottom: 12, trailing: 0))
                }
                .listItemTint(Color("AstroGray"))
                NavigationLink(destination: Profile()) {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Circle().frame(width: 42)
                                .foregroundColor(Color("AstroRed"))
                            Image(systemName: "figure.arms.open")
                                .font(.system(size: 21,weight: .bold))
                        }
                        .padding(.bottom, 8)
                        Text("Profile")
                            .font(.system(size: 21,weight: .bold))
                        Text("Medical Records")
                            .font(.system(size: 13,weight: .regular))
                            .foregroundColor(Color.gray)
                    }
                    .padding(EdgeInsets(top: 12, leading: 6, bottom: 12, trailing: 0))
                }
                .listItemTint(Color("AstroGray"))
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
