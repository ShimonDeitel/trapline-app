import Foundation

struct LogEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var camera: String
    var species: String
    var notes: String
    var date: Date = Date()
}
