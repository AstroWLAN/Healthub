import Foundation

struct Therapy : Identifiable, Hashable {
    private(set) var id: Int
    private(set) var name: String
    // Può anche essere una stringa... basta il nome del medico
    private(set) var doctor: Doctor?
    private(set) var duration: String
    // Rendere drug un array ( ogni terapia può avere molteplici farmaci )
    // Può anche essere un array di stringhe... basta solo il nome del farmaco
    private(set) var drug: Drug?
    private(set) var notes: String
    private(set) var interactions: [String]
}
