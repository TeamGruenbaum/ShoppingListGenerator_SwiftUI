class IngredientDataAccessor:DataAccessor
{
    static let instance:IngredientDataAccessor=IngredientDataAccessor();
    
    private init(){}
    

    typealias T = Ingredient

    func getAllElements()->[Ingredient]
    {
        do
        {
            return try CoreDataLayer.instance.persistentContainer.viewContext.fetch(Ingredient.fetchRequest());
        }
        catch
        {
            return [];
        }
    };
    
    func getEmptyElement()->Ingredient
    {
        return Ingredient(context: CoreDataLayer.instance.persistentContainer.viewContext)
    }
    
    func deleteElement(element:Ingredient)->Void
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
