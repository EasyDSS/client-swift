/* -- */

import Foundation

extension Encodable {
    func mapped<T: Decodable>(to type: T.Type,
                              encoder: JSONEncoder = JSONEncoder(),
                              decoder: JSONDecoder = JSONDecoder()) -> T?
    {
        guard let encoded = try? encoder.encode(self),
              let decoded = try? decoder.decode(type, from: encoded) else { return nil }

        return decoded
    }
}
