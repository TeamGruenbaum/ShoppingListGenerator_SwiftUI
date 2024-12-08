import CoreData

class CoreDataLayer
{
    static let instance:CoreDataLayer = CoreDataLayer();
    
    private init(){}


    let persistentContainer:NSPersistentContainer =
    {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler:
        {(storeDescription, error) in
              if let error = (error as NSError?)
              {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
        })

        return container;
    }();
}
