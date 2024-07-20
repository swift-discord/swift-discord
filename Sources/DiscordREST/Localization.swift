//
//  Localization.swift
//
//
//  Created by Jaehong Kang on 7/15/24.
//

public enum Locale: String, Sendable, Codable {
    case id
    case da
    case de
    case en_GB = "en-GB"
    case en_US = "en-US"
    case es_ES = "es-ES"
    case es_419 = "es-419"
    case fr
    case hr
    case it
    case lt
    case hu
    case nl
    case no
    case pl
    case pt_BR = "pt-BR"
    case ro
    case fi
    case sv_SE = "sv-SE"
    case vi
    case tr
    case cs
    case el
    case bg
    case ru
    case uk
    case hi
    case th
    case zh_CN = "zh-CN"
    case ja
    case zh_TW = "zh-TW"
    case ko
}

public typealias Localizations = [Locale: String]
