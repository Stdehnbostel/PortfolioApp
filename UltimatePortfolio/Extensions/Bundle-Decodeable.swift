//
//  Bundle-Decodeable.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.02.26.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(
        _ file: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("failed to locate \(file) in Bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failded to load \(file) from Bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError(
                // swiftlint:disable:next line_length
                "Failed to decode \(file) from Bundle due to missing key '\(key.stringValue)' - \(context.debugDescription)"
            )
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError(
                "Failed to decode \(file) from Bundle due to type mismatch - \(context.debugDescription)"
            )
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError(
                "Failed to decode \(file) from Bundle due to missing \(type) value - \(context.debugDescription)"
            )
        } catch DecodingError.dataCorrupted(_) {
            fatalError(
                "Failed to decode \(file) from Bundle becaue it appears to be invalid JSON"
            )
        } catch {
            fatalError(
                "Failed to decode \(file) from Bundle \(error.localizedDescription)"
            )
        }
    }
}
