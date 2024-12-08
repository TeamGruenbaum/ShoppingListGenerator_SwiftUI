class DishDataAccessor:DataAccessor
{
    static let instance:DishDataAccessor=DishDataAccessor();
    
    private init(){}
    

    typealias T = Dish

    func getAllElements()->[Dish]
    {
        do
        {
            return try CoreDataLayer.instance.persistentContainer.viewContext.fetch(Dish.fetchRequest());
        }
        catch
        {
            return [];
        }
    };
    
    func getEmptyElement()->Dish
    {
        return Dish(context: CoreDataLayer.instance.persistentContainer.viewContext)
    }
    
    func deleteElement(element:Dish)->Void
    {
        CoreDataLayer.instance.persistentContainer.viewContext.delete(element);
    }
    
    func applyChanges()->Void
    {
        do
        {
            try CoreDataLayer.instance.persistentContainer.viewContext.save();
        }
        catch
        {
            print("Saving not possible")
        }
    };
}
