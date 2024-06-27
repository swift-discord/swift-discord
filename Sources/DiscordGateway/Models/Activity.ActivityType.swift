//
//  Activity.ActivityType.swift
//  
//
//  Created by Mina Her on 2022/08/01.
//

extension Activity {

    public struct ActivityType: Codable, Hashable, RawRepresentable, Sendable {

        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension Activity.ActivityType {

    public static let game: Self = .init(0)

    public static let streaming: Self = .init(1)

    public static let listening: Self = .init(2)

    public static let watching: Self = .init(3)

    public static let custom: Self = .init(4)

    public static let competing: Self = .init(5)

    private init(_ intValue: Int) {
        rawValue = intValue
    }
}
