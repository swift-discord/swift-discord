//
//  Weak.swift
//
//
//  Created by Jaehong Kang on 7/20/24.
//

public class Weak<O: AnyObject> {
    public weak var base: O?

    public init(_ base: O?) {
        self.base = base
    }
}

extension Weak: Equatable where O: Equatable {
    public static func == (lhs: Weak<O>, rhs: Weak<O>) -> Bool {
        lhs.base == rhs.base
    }
}

extension Weak: Hashable where O: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
}
