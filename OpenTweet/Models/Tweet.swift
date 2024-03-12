import Foundation
import Alamofire

enum DecodableFailed: Error {
    case invalidRequiredParameter
}

struct Tweet: Decodable {
    let id: Int
    let author: String
    let avatarURL: URL?
    let content: String
    let date: Date
    let inReplyTo: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case avatarURL
        case content
        case date
        case inReplyTo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idText = try container.decode(String.self, forKey: .id)
        
        guard let idPrimitive = Int(idText) else {
            throw DecodableFailed.invalidRequiredParameter
        }
        
        self.id = idPrimitive
        self.author = try container.decode(String.self, forKey: .author)
        self.avatarURL = try container.decodeIfPresent(URL.self, forKey: .avatarURL)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = try container.decode(Date.self, forKey: .date)
        
        if let inReplyToText = try container.decodeIfPresent(String.self, forKey: .inReplyTo) {
            self.inReplyTo = Int(inReplyToText)
        } else {
            self.inReplyTo = nil
        }
    }
}
