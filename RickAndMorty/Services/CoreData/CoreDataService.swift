import Foundation
import CoreData

enum CoreDataServiceError: Error {
    case failCastToType(String)
}
final class CoreDataService {

    private let persistenteStorageContainer: NSPersistentContainer
    private var context: NSManagedObjectContext { persistenteStorageContainer.viewContext }

    init(model: String) {
        let container = NSPersistentContainer(name: model)
        container.loadPersistentStores { _, error  in
            if let error = error as NSError? {
                fatalError("Failed to initialize CoreData Stack: \(error.localizedDescription), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.persistenteStorageContainer = container
    }

    @discardableResult
    func saveChanges() throws -> Bool {
        guard context.hasChanges else { return true }
        try context.save()
        return true
    }
    func createObject<T: NSManagedObject>(from entity: T.Type) throws -> T {
        guard let object = NSEntityDescription.insertNewObject(
            forEntityName: String(describing: entity),
            into: context
        ) as? T else {
            throw CoreDataServiceError.failCastToType(T.description())
        }
        return object
    }

    @discardableResult
    func deleteObject(_ object: NSManagedObject) throws -> Bool {
        context.delete(object)
        return try saveChanges()
    }

    func deleteAllObjects<T: NSManagedObject>(ofType entity: T.Type) throws {
        let request = entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        try persistenteStorageContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
    }

    func fetchObjects<T: NSManagedObject>(
        ofType entity: T.Type,
        sortBy sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        guard let request = entity.fetchRequest() as? NSFetchRequest<T> else { return [] }
        request.sortDescriptors = sortDescriptors
        return try context.fetch(request)
    }
}
