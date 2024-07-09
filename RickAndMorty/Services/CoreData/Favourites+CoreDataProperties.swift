import Foundation
import CoreData

extension Favourites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourites> {
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }

    @NSManaged public var id: Int16
    @NSManaged public var imageData: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?

}
