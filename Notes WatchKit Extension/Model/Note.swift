//
//  Note.swift
//  Notes WatchKit Extension
//
//  Created by Ashish Sharma on 01/04/2023.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
}
