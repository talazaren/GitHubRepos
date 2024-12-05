//
//  ExtensionsTests.swift
//  GitHubReposTests
//
//  Created by Tatiana Lazarenko on 12/5/24.
//

import XCTest
@testable import GitHubRepos

struct TestItem: Identifiable, Equatable {
    let id: Int
    let name: String
}

final class ExtensionsTests: XCTestCase {
    
// MARK: - isLast Tests
    func testIsLast_itemIsLastInCollection() {
        let items: [TestItem] = [
            TestItem(id: 1, name: "Item1"),
            TestItem(id: 2, name: "Item2"),
            TestItem(id: 3, name: "Item3")
        ]
        
        let result = items.isLast(TestItem(id: 3, name: "Item3"))
        
        XCTAssertTrue(result, "Expected the item to be the last in the collection.")
    }
    
    func testIsLast_itemIsNotLastInCollection() {
        let items: [TestItem] = [
            TestItem(id: 1, name: "Item1"),
            TestItem(id: 2, name: "Item2"),
            TestItem(id: 3, name: "Item3")
        ]
        
        let result = items.isLast(TestItem(id: 2, name: "Item2"))
        
        XCTAssertFalse(result, "Expected the item to not be the last in the collection.")
    }
    
    func testIsLast_emptyCollection() {
        let items: [TestItem] = []
        
        let result = items.isLast(TestItem(id: 1, name: "Item1"))
        
        XCTAssertFalse(result, "Expected the result to be false for an empty collection.")
    }
    
    func testIsLast_itemNotInCollection() {
        let items: [TestItem] = [
            TestItem(id: 1, name: "Item1"),
            TestItem(id: 2, name: "Item2")
        ]
        
        let result = items.isLast(TestItem(id: 3, name: "Item3"))
        
        XCTAssertFalse(result, "Expected the result to be false for an item not in the collection.")
    }
    
// MARK: - StringtoDate Tests
    func testToDate_validISO8601String() {
        let date = Date()
        let dateString = formatDateToString(date)
        
        let result = dateString.toDate() ?? Date()
        
        XCTAssertEqual(formatDateToString(result), formatDateToString(date), "Expected the string to convert to the correct date.")
    }
    
    func testToDate_invalidString() {
        let dateString = "InvalidDate"
        
        let result = dateString.toDate()
        
        XCTAssertNil(result, "Expected the result to be nil for an invalid date string.")
    }
    
    func testToDate_partialDateString() {
        let dateString = "2024-12-01"
        
        let result = dateString.toDate()
        
        XCTAssertNil(result, "Expected the result to be nil for a partial date string.")
    }
    
// MARK: - Helper for tests
    private func formatDateToString(_ date: Date) -> String {
        date.formatted(.iso8601
            .year()
            .month()
            .day()
            .timeZone(separator: .omitted)
            .time(includingFractionalSeconds: false)
            .timeSeparator(.colon)
        )
    }
}
