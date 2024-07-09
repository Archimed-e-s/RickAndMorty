import Foundation

final class CharacterCollectionModelCell {

    let characterID: Int
    private let planetName: RMOrigin
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    public let characterCreated: String
    var characterImageURL: URL?

    init(
        characterID: Int,
        planetName: RMOrigin,
        characterName: String,
        characterStatus: RMCharacterStatus,
        characterCreated: String,
        characterImageURL: URL?
    ) {
        self.characterID = characterID
        self.planetName = planetName
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterCreated = characterCreated
        self.characterImageURL = characterImageURL
    }
    public var characterStatusText: String {
        return characterStatus.rawValue
    }

    public var planetNameText: String {
        return planetName.name
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
