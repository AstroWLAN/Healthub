//
//  Therapy.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
struct Therapy: Identifiable, Hashable{
    private(set) var id: Int
    private(set) var doctor: Doctor?
    private(set) var duration: String
    private(set) var drug: Drug?
    private(set) var comment: String
    private(set) var name: String
    private(set) var interactions: [String]
}
