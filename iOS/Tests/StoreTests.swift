import XCTest
@testable import Trapline

final class StoreTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(LogEntry(camera: "Test", species: "Value", notes: "Note"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testNewestEntryInsertedFirst() {
        store.add(LogEntry(camera: "First", species: "A", notes: ""))
        store.add(LogEntry(camera: "Second", species: "B", notes: ""))
        XCTAssertEqual(store.entries.first?.camera, "Second")
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtFreeLimit() {
        for i in 0..<Store.freeTierLimit {
            store.add(LogEntry(camera: "Item \(i)", species: "V", notes: ""))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBeyondLimitIsNoOp() {
        for i in 0..<Store.freeTierLimit {
            store.add(LogEntry(camera: "Item \(i)", species: "V", notes: ""))
        }
        let countAtLimit = store.entries.count
        store.add(LogEntry(camera: "Overflow", species: "V", notes: ""))
        XCTAssertEqual(store.entries.count, countAtLimit)
    }

    func testDeleteAtOffsetsRemovesEntry() {
        store.add(LogEntry(camera: "ToDelete", species: "V", notes: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntryModifiesExisting() {
        store.add(LogEntry(camera: "Original", species: "V", notes: ""))
        var entry = store.entries[0]
        entry.camera = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries[0].camera, "Updated")
    }

    func testFreeTierLimitExceedsSeedCount() {
        XCTAssertGreaterThan(Store.freeTierLimit, 3)
    }
}
