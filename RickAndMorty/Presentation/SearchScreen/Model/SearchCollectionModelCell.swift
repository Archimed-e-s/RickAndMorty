import Foundation

final class SearchCollectionModelCell {

    let planetName: RMOrigin
    let characterName: String
    let characterImageURL: URL?
    let characterID: Int

    init(
        planetName: RMOrigin,
        characterName: String,
        characterImageURL: URL?,
        characterID: Int
    ) {
        self.planetName = planetName
        self.characterName = characterName
        self.characterImageURL = characterImageURL
        self.characterID = characterID
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
