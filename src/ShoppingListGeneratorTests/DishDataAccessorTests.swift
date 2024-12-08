import XCTest
@testable import ShoppingListGenerator;
import CoreData;

class DishDataAccessorTests: XCTestCase
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
    
    
    func testAGetEmptyDish() throws
    {
        let emptyDish:Dish=DishDataAccessor.instance.getEmptyElement();
        XCTAssertEqual(emptyDish.id, nil);
        XCTAssertEqual(emptyDish.name, nil);
        XCTAssertEqual(emptyDish.recipe, nil)
        XCTAssertEqual(emptyDish.ingredients?.count, Int(0));
    }
    
    func testBGetAllDishesIfEmpty() throws
    {
        XCTAssertEqual(DishDataAccessor.instance.getAllElements(), []);
    }
    
    func testCGetAllDishesIfNotEmpty()
    {
        let dishName:String="Sandwich";
        let dishRecipe:String="Brot belegen";
        let ingredientName:String="Tomate";
        let ingredientStore:String="EDEKA";
        let ingredientShelf:Int16=1;
        
        addDish(name: dishName, recipe: dishRecipe, ingredients: [createIngredientWithNoDishes(name: ingredientName, store: ingredientStore, shelf: ingredientShelf)]);
        
        let allDishes=DishDataAccessor.instance.getAllElements();
        XCTAssertEqual(allDishes.count, 1);
        
        let firstDish:Dish=allDishes[0];
        XCTAssertNotNil(firstDish.id)
        XCTAssertEqual(firstDish.name, dishName);
        XCTAssertEqual(firstDish.recipe, dishRecipe);
        
        guard let ingredientFromFirstDish:Ingredient = (firstDish.ingredients?.allObjects as? [Ingredient])?.first else
        {
            XCTFail();
            return;
        }
        
        XCTAssertNotNil(ingredientFromFirstDish.id);
        XCTAssertEqual(ingredientFromFirstDish.name, ingredientName);
        XCTAssertEqual(ingredientFromFirstDish.store, ingredientStore);
        XCTAssertEqual(ingredientFromFirstDish.shelf, ingredientShelf);
    }
    
    func testDDeleteDish()
    {
        let ingredientName:String="Tomate";
        let ingredientStore:String="EDEKA";
        let ingredientShelf:Int16=1;
        
        let newDish:Dish=addDish(name: "Sandwich", recipe: "Brot belegen", ingredients: [createIngredientWithNoDishes(name: ingredientName, store: ingredientStore, shelf: ingredientShelf)]);
        
        var allDishes=DishDataAccessor.instance.getAllElements();
        XCTAssertEqual(allDishes.count, 1);
        
        DishDataAccessor.instance.deleteElement(element: newDish)
        DishDataAccessor.instance.applyChanges();
        
        allDishes=DishDataAccessor.instance.getAllElements();
        XCTAssertEqual(allDishes.count, 0);
        
        
        let allIngredients:[Ingredient] = IngredientDataAccessor.instance.getAllElements();
        XCTAssertEqual(allIngredients.count, 1)
        
        guard let firstIngredient:Ingredient=allIngredients.first else
        {
            XCTFail();
            return;
        }
        
        XCTAssertNotNil(firstIngredient.id);
        XCTAssertEqual(firstIngredient.name, ingredientName);
        XCTAssertEqual(firstIngredient.store, ingredientStore);
        XCTAssertEqual(firstIngredient.shelf, ingredientShelf);
    }
    
    private func addDish(name:String, recipe:String, ingredients:[Ingredient])->Dish
    {
        let newDish:Dish=DishDataAccessor.instance.getEmptyElement();
        newDish.id=UUID();
        newDish.name=name;
        newDish.recipe=recipe;
        
        if(ingredients.count != 0)
        {
            for ingredient in ingredients
            {
                newDish.addToIngredients(ingredient);
            }
        }
        
        DishDataAccessor.instance.applyChanges();
        return newDish;
    }
    
    private func createIngredientWithNoDishes(name:String, store:String, shelf:Int16)->Ingredient
    {
        let newIngredient:Ingredient=IngredientDataAccessor.instance.getEmptyElement();
        newIngredient.id=UUID();
        newIngredient.name=name;
        newIngredient.store=store;
        newIngredient.shelf=shelf;
        
        return newIngredient;
    }
}

