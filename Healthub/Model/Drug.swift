import Foundation

struct Drug : Identifiable, Hashable {
    private(set) var id: Int
    private(set) var group_description: String
    private(set) var ma_holder: String
    private(set) var equivalence_group_code: String
    private(set) var denomination_and_packaging: String
    private(set) var active_principle: String
    private(set) var ma_code: String
}
