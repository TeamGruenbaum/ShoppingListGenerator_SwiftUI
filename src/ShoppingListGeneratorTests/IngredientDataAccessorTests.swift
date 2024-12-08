import XCTest
@testable import ShoppingListGenerator;
import CoreData;

class IngredientDataAccessorTests: XCTestCase
{
    override func setUpWithError() throws
    {
        func deleteAllObjects(entityName:String) throws
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            let results = try CoreDataLayer.instance.persistentContainer.viewContext.fetch(fetchRequest)
            for result in results
            {
                guard let resultManagedObject = result as? NSManagedObject else
                {
                    continue;
                }
                
                CoreDataLayer.instance.persistentContainer.viewContext.delete(resultManagedObject)
            }
        }
        
        try deleteAllObjects(entityName: "Ingredient");
        try deleteAllObjects(entityName: "Dish");
    }
    
    
    func testAGetEmptyIngredient() throws
    {
        let emptyIngredient:Ingredient=IngredientDataAccessor.instance.getEmptyElement();
        XCTAssertEqual(emptyIngredient.id, nil);
        XCTAssertEqual(emptyIngredient.name, nil);
        XCTAssertEqual(emptyIngredient.store, nil)
        XCTAssertEqual(emptyIngredient.shelf, Int16(0))
        XCTAssertEqual(emptyIngredient.dishes?.count, Int(0));
    }
    
    func testBGetAllIngredientsIfEmpty() throws
    {
        print(IngredientDataAccessor.instance.getAllElements())
        XCTAssertEqual(IngredientDataAccessor.instance.getAllElements(), []);
    }
    
    func testCGetAllIngredientsIfNotEmpty()
    {
        let ingredientName:String="Tomate";
        let ingredientStore:String="EDEKA";
        let ingredientShelf:Int16=1;
        let dishName:String="Sandwich";
        let dishRecipe:String="Brot belegen";
        
        addIngredient(name: ingredientName, store: ingredientStore, shelf: ingredientShelf, dishes: [createDishWithNoIngredients(name: dishName, recipe: dishRecipe)])
        
        let allIngredients=IngredientDataAccessor.instance.getAllElements();
        XCTAssertEqual(allIngredients.count, 1);
        
        let firstIngredient:Ingredient=allIngredients[0];
        XCTAssertNotNil(firstIngredient.id)
        XCTAssertEqual(firstIngredient.name, ingredientName);
        XCTAssertEqual(firstIngredient.store, ingredientStore);
        XCTAssertEqual(firstIngredient.shelf, ingredientShelf);
        
        guard let dishFromFirstIngredient:Dish = (firstIngredient.dishes?.allObjects as? [Dish])?.first else
        {
            XCTFail();
            return;
        }
        
        XCTAssertNotNil(dishFromFirstIngredient.id);
        XCTAssertEqual(dishFromFirstIngredient.name, dishName);
        XCTAssertEqual(dishFromFirstIngredient.recipe, dishRecipe);
    }
    
    func testDDeleteIngredient()
    {
        let dishName:String="Sandwich";
        let dishRecipe:String="Brot belegen";
        
        
        let newIngredient:Ingredient=addIngredient(name: "Tomate", store: "EDEKA", shelf: 1, dishes: [createDishWithNoIngredients(name: dishName, recipe: dishRecipe)])
        
        var allIngredients=IngredientDataAccessor.instance.getAllElements();
        XCTAssertEqual(allIngredients.count, 1);
        
        IngredientDataAccessor.instance.deleteElement(element: newIngredient);
        IngredientDataAccessor.instance.applyChanges();
        
        allIngredients=IngredientDataAccessor.instance.getAllElements();
        XCTAssertEqual(allIngredients.count, 0);
        
        
        let allDishes:[Dish] = DishDataAccessor.instance.getAllElements();
        XCTAssertEqual(allDishes.count, 1)
        
        guard let firstDish:Dish=allDishes.first else
        {
            XCTFail();
            return;
        }
        
        XCTAssertNotNil(firstDish.id);
        XCTAssertEqual(firstDish.name, dishName);
        XCTAssertEqual(firstDish.recipe, dishRecipe);
    }
    
    private func addIngredient(name:String, store:String, shelf:Int16, dishes:[Dish])->Ingredient
    {
        let newIngredient:Ingredient=IngredientDataAccessor.instance.getEmptyElement();
        
        newIngredient.id=UUID();
        newIngredient.name=name;
        newIngredient.store=store;
        newIngredient.shelf=shelf;
        
        if(dishes.count != 0)
        {
            for dish in dishes
            {
                newIngredient.addToDishes(dish);
            }
        }
        
        IngredientDataAccessor.instance.applyChanges();
        
        return newIngredient;
    }
    
    private func createDishWithNoIngredients(name:String, recipe:String)->Dish
    {
        let newDish:Dish=DishDataAccessor.instance.getEmptyElement();
        newDish.id=UUID();
        newDish.name=name;
        newDish.recipe=recipe;
        
        return newDish;
    }
}
