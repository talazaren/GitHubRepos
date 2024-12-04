//
//  RandomAccessCollection+.swift
//  GitHubRepos
//
//  Created by Tatiana Lazarenko on 12/2/24.
//

import Foundation

extension RandomAccessCollection where Self.Element: Identifiable {
    public func isLast(_ item: Element) -> Bool {
        guard isEmpty == false else { return false }
        guard let index = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else { return false }
        
        return distance(from: index, to: endIndex) == 1
    }
}
