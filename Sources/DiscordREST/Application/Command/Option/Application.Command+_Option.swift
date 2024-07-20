//
//  Application.Command+_Option.swift
//
//
//  Created by Jaehong Kang on 7/15/24.
//

extension Application.Command {
    public protocol _Option: Sendable, Codable {
        var type: OptionType { get }
        var name: String { get }
        var nameLocalizations: Localizations? { get }
        var description: String { get }
        var descriptionLocalizations: Localizations? { get }
    }

    public enum OptionType: Int, Sendable, Codable {
        case subCommand = 1
        case subCommandGroup
        case string
        case integer
        case boolean
        case user
        case channel
        case role
        case mentionable
        case number
        case attachment
    }

    public protocol SubOption: _Option {
        var options: [any _Option]? { get }
    }

    public protocol RequirableOption: _Option {
        var required: Bool? { get }
    }

    public protocol ChoicableOption<Value>: _Option where Value: Sendable, Value: Codable {
        associatedtype Value
        var choices: [Choice<Value>]? { get }
    }

    public struct Choice<Value>: Sendable, Codable where Value: Sendable, Value: Codable {
        public let name: String
        public let nameLocalizations: Localizations?
        public let value: Value
    }

    public protocol ValueTypeOption<Value>: _Option where Value: Strideable {
        associatedtype Value
        var minValue: Value? { get }
        var maxValue: Value? { get }
    }

    public protocol AutocompletableOption: _Option {
        var autocomplete: Bool? { get }
    }
}
