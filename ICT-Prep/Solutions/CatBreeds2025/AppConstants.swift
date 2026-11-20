//
//  AppConstants.swift
//  Cat Breeds Explorer (reference solution)
//
//  "Code Quality: constants usage, minimal hardcoding" (5 marks). Every URL and
//  storage key lives here once.
//

import Foundation

enum AppConstants {

    enum API {
        static let breedsURL = "https://api.thecatapi.com/v1/breeds"
        static let imageBaseURL = "https://cdn2.thecatapi.com/images/"
        static let imageExtension = ".jpg"

        /// TheCatAPI may answer 403 "Authentication required" without a key.
        /// Get a free key at thecatapi.com and paste it here. Empty = no header sent.
        static let apiKey = ""
        static let apiKeyHeader = "x-api-key"
    }

    enum StorageKeys {
        static let userName = "userName"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
}
