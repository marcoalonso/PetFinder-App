//
//  PetfinderResponse.swift
//  PetFinder App
//
//  Created by Marco Alonso Rodriguez on 27/01/24.
//

import Foundation


// MARK: - Welcome
struct PetfinderResponse: Codable {
    let animals: [Animal]
    let pagination: Pagination
}

// MARK: - Animal
struct Animal: Codable {
    let id: Int
    let organizationID: String
    let url: String
    let type, species: String
    let breeds: Breeds
    let colors: Colors
    let age, gender, size, coat: String
    let name, description: String
    let photos: [Photo]
    let videos: [Video]
    let status: String
    let attributes: Attributes
    let environment: Environment
    let tags: [String]
    let contact: Contact
    let publishedAt: Date
    let distance: Double
    let links: AnimalLinks

    enum CodingKeys: String, CodingKey {
        case id
        case organizationID = "organization_id"
        case url, type, species, breeds, colors, age, gender, size, coat, name, description, photos, videos, status, attributes, environment, tags, contact
        case publishedAt = "published_at"
        case distance
        case links = "_links"
    }
}

// MARK: - Attributes
struct Attributes: Codable {
    let spayedNeutered, houseTrained, declawed, specialNeeds: Bool
    let shotsCurrent: Bool

    enum CodingKeys: String, CodingKey {
        case spayedNeutered = "spayed_neutered"
        case houseTrained = "house_trained"
        case declawed
        case specialNeeds = "special_needs"
        case shotsCurrent = "shots_current"
    }
}

// MARK: - Breeds
struct Breeds: Codable {
    let primary: String
    let secondary: JSONNull?
    let mixed, unknown: Bool
}

// MARK: - Colors
struct Colors: Codable {
    let primary: String
    let secondary, tertiary: JSONNull?
}

// MARK: - Contact
struct Contact: Codable {
    let email, phone: String
    let address: Address
}

// MARK: - Address
struct Address: Codable {
    let address1, address2: JSONNull?
    let city, state, postcode, country: String
}

// MARK: - Environment
struct Environment: Codable {
    let children, dogs, cats: Bool
}

// MARK: - AnimalLinks
struct AnimalLinks: Codable {
    let linksSelf, type, organization: Organization

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case type, organization
    }
}

// MARK: - Organization
struct Organization: Codable {
    let href: String
}

// MARK: - Photo
struct Photo: Codable {
    let small, medium, large, full: String
}

// MARK: - Video
struct Video: Codable {
    let embed: String
}

// MARK: - Pagination
struct Pagination: Codable {
    let countPerPage, totalCount, currentPage, totalPages: Int
    let links: PaginationLinks

    enum CodingKeys: String, CodingKey {
        case countPerPage = "count_per_page"
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case links = "_links"
    }
}

// MARK: - PaginationLinks
struct PaginationLinks: Codable {
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
