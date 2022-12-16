import SwiftUI

struct GenderSheet : View {
    
    @Binding var userGender : Gender
    
    var body : some View {
        Picker(String(), selection: $userGender) {
            ForEach(Gender.allCases, id:\.self) { gender in
                Text("\(gender.rawValue.capitalized)")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}

struct HeightSheet : View {
    
    @Binding var userHeight : String
    
    var body : some View {
        VStack {
            Picker(String(), selection: $userHeight) {
                ForEach((120...201).map(String.init), id:\.self) { height in
                    Text(height+" cm")
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct WeightSheet : View {
    
    @Binding var userWeight : String
    
    var body : some View {
        Picker(String(), selection: $userWeight) {
            ForEach((40...181).map(String.init), id:\.self) { weight in
                Text(weight+" kg")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}

struct BirthdateSheet : View {
    
    @Binding var birthdate : Date
    
    var body : some View {
        DatePicker(String(), selection: $birthdate,in: ...Date(), displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
    }
}

struct DayPicker : View {
    
    @Binding var examinationDate : Date
    //.addingTimeInterval(86400)...
    var body : some View {
        DatePicker(String(), selection: $examinationDate, in: ...Date(), displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
    }
}

struct SlotPicker : View {
    
    @EnvironmentObject private var ticketViewModel : TicketViewModel
    @Binding var examinationTimeSlot : String
    
    var body : some View { //.tag(ticketViewModel.slots.firstIndex(of: slot)!)
        Picker(String(), selection: $examinationTimeSlot){
            Text("")
            ForEach(ticketViewModel.slots, id: \.self) { slot in
                Text(String(slot))
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}
