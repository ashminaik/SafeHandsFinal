import Foundation
import CoreLocation

struct TherapyPlace: Identifiable {
    let id: String
    let name: String
    let address: String
    let rating: Double?
    let distance: Double?
    let types: [String]
}

struct GooglePlacesService {

    // MARK: - Mock Data (Gurugram therapy centers)

    static func searchNearbyTherapy(
        latitude: Double,
        longitude: Double,
        radiusMeters: Double = 10000
    ) async throws -> [TherapyPlace] {
        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(800))
        return mockPlaces
    }

    static func cachedSearch(
        latitude: Double,
        longitude: Double
    ) async throws -> [TherapyPlace] {
        return try await searchNearbyTherapy(
            latitude: latitude,
            longitude: longitude
        )
    }

    // MARK: - Hardcoded Real Therapy Centers

    private static let mockPlaces: [TherapyPlace] = [
        TherapyPlace(
            id: "place_001",
            name: "Rainbow Child Development Centre",
            address: "H.No 56, DLF Phase 5, Sector 43, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_002",
            name: "Continua Kids",
            address: "NS-11W, Nirvana Country, Sector 50, Gurugram",
            rating: 4.7,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_003",
            name: "Beautiful Mind Therapy Centre",
            address: "House No 77, Sector 5, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA"]
        ),
        TherapyPlace(
            id: "place_004",
            name: "Blooming Words Centers",
            address: "60 Block H, Greenwood City, Sector 46, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_005",
            name: "Babblz Child Development Centre",
            address: "B-747A, Near Galleria Market, Sector 28, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA"]
        ),
        TherapyPlace(
            id: "place_006",
            name: "Medick Curo Child Development Centre",
            address: "H.No 1650, Sohna Road, Sector 45, Gurugram",
            rating: 4.7,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_007",
            name: "Sunshine By Lissun",
            address: "Plot J-81, Mayfield Garden, Sector 51, Gurugram",
            rating: 4.6,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_008",
            name: "The Child An Inclusive Therapy Program",
            address: "D Block, Greenwood City, Sector 46, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        )
    ]
}
