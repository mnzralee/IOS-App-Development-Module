//
//  AddEditShowViewModel.swift
//  Encore
//
//  Created by Manazir Ali on 2026-11-10.
//

import Foundation

@Observable
final class AddEditShowViewModel {
    
    var artistName = ""
    var venueName = ""
    var city = ""
    var date = Date()
    var status: ShowStatus = .upcoming
    var rating: Int = 0
    var notes = ""
    var setlist: [String] = []
    var newSetListEntry = ""
    
    var isValid: Bool {
        !artistName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !venueName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(show: Show? = nil, initialStatus: ShowStatus = .upcoming) {
        
    }
    
}
