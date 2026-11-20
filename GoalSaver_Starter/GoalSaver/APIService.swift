//
//  APIService.swift
//  GoalSaver
//
//  Created by Manazir Ali on 2026-11-19.
//
import Foundation

// MARK: - Model
// If you already have this type elsewhere in your project, you can remove this
// and use the shared model definition instead.
public struct SavingRecord: Codable, Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let amount: Double
    public let date: Date
}

// MARK: - API Service

    /*
        func fetchMovieData() async {
            guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            do {
                let (data, urlResponse) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    return
                }
                
                let decodedMovies = try JSONDecoder().decode([MovieDTO].self, from: data)
                self.movies = decodedMovies
                
            } catch {
                print("Something went wrong, please try again.")
            }
        }
     */

