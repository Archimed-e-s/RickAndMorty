import CoreData
import UIKit

public final class CoreDataManager: NSObject {

    public static let shared = CoreDataManager()

    private override init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    public func logCoreDataDBPath() {
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
        }
    }

    public func addFavourite(
        _ id: Int16,
        _ imageData: String?,
        _ name: String?,
        _ isFavourite: Bool
    ) {
        guard let favouriteEntityDescription = NSEntityDescription.entity(
            forEntityName: "Favourites",
            in: context
        ) else {
            return
        }
        let favourites = Favourites(entity: favouriteEntityDescription, insertInto: context)
        favourites.id = id
        favourites.imageData = imageData
        favourites.name = name
        favourites.isFavourite = isFavourite
        appDelegate.saveContext()
    }

    public func fetchAllFavourites() -> [Favourites] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        do {
            return try context.fetch(fetchRequest) as! [Favourites]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    public func fetchFavourite(with id: Int16) -> Favourites? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        do {
            guard let favourites = try? context.fetch(fetchRequest) as? [Favourites] else { return nil }
            return favourites.first(where: { $0.id == id })
        }
    }

    public func updateAll() -> [Favourites] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        do {
            guard let favourites = try? context.fetch(fetchRequest) as? [Favourites] else { return [] }
            appDelegate.saveContext()
            return favourites
        }
    }

    public func deleteAllFavourites() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        do {
            let favourites = try? context.fetch(fetchRequest) as? [Favourites]
            favourites?.forEach({ context.delete($0)})
        }
        appDelegate.saveContext()
    }

    public func deleteFavourites(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        do {
            guard let favourites = try? context.fetch(fetchRequest) as? [Favourites],
                  let favourite = favourites.first(where: { $0.id == id })  else { return }
            context.delete(favourite)
        }
        appDelegate.saveContext()
    }

    public func getRecordsCount() {
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
          do {
              let count = try context.count(for: fetchRequest)
              print("count of records in CoreData: \(count) now!")
          } catch {
              print(error.localizedDescription)
          }
      }
}
