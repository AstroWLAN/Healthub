import Foundation

struct Pathology : Hashable {
    
    private(set) var id : Int
    private(set) var name : String
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
}
