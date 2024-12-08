import XCTest
import ShoppingListGenerator
import OrderedCollections

//Es wird empfohlen beim Simulator die Option "I/O"->"Keyboard"->"Connect Hardware Keyboard" auszuschalten, da sich der Simulator sonst häufig vertippt.
//Manchmal passiert dies dennoch, dann würden wir Sie bitten die fehlgeschlagenen Tests weitere Male zu probieren.
//Zudem wird vor jedem Test die App deinstalliert. Um dies zu ermöglichen muss die Systemsprache des Simulators auf Englisch gestellt sein.
class ShoppingListGeneratorUITests: XCTestCase
{
    let app:XCUIApplication = XCUIApplication();


    
    override func setUpWithError() throws
    {
        super.continueAfterFailure = false
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        XCUIApplication().terminate()
        
        let icon = springboard.icons["ShoppingListGenerator"]
        if icon.exists
        {
            icon.press(forDuration: 1)

            springboard.buttons["Remove App"].tap();
            sleep(1);
            springboard.alerts.buttons["Delete App"].tap();
            sleep(1);
            springboard.alerts.buttons["Delete"].tap();
        }
        
        app.launch();
    }

    
    
    func testA_addIngredient()->Void
    {
        let name:String="Apfel";
        let store:String="Lidl";
        let shelf:Int16=1;
        addIngredient(name: name, store: store, shelf: shelf)
        let newIngredient:XCUIElement=app.staticTexts[name];
        XCTAssertTrue(newIngredient.exists)
        
        newIngredient.tap();
        
        
        XCTAssertEqual(app.staticTexts["ingredientNameText"].label, name);
        XCTAssertEqual(app.staticTexts["ingredientStoreText"].label, store);
        XCTAssertEqual(app.staticTexts["ingredientShelfText"].label, String(shelf));
    }
    
    func testB_deleteIngredient()
    {
        let name:String="Pizzateig";
        addIngredient(name: name, store:"Lidl", shelf:3);

        app.cells.element(boundBy: 0)
            .coordinate(withNormalizedOffset: CGVector(dx:0.95,dy:0.5))
            .press(forDuration: 0.1, thenDragTo:
                    app.cells.element(boundBy: 0)
                    .coordinate(withNormalizedOffset:CGVector(dx: 0.05, dy: 0.5))
            )
        XCTAssertFalse(app.staticTexts[name].exists)
    }
    
    func testC_editIngredient()
    {
        let oldShelf:Int16=6;
        addIngredient(name: "Wasser", store: "Lidl", shelf: oldShelf)
        
        app.staticTexts["Wasser"].tap();
        
        app.buttons["ingredientEditButton"].tap();
        
        let name:String = "Volvic";
        let store:String = "EDEKA";
        let shelf:Int16 = 7;
        
        app.textFields["ingredientNameTextField"].clearAndEnterText(text: name);
        app.textFields["ingredientStoreTextField"].clearAndEnterText(text: store);
        app.setStepperValue(accessibilityIdentifier: "ingredientShelfStepper", currentValue: Int(oldShelf), targetValue: Int(shelf))
        
        app.buttons["ingredientDoneButton"].tap();
        
        XCTAssertEqual(app.staticTexts["ingredientNameText"].label, name);
        XCTAssertEqual(app.staticTexts["ingredientStoreText"].label, store);
        XCTAssertEqual(app.staticTexts["ingredientShelfText"].label, String(shelf));
    }
    
    func testE_addDish()
    {
        let ingredientName:String = "Kalbsfleisch";
        let ingredientStore:String="EDEKA";
        let ingredientShelf:Int16=4;
        addIngredient(name: ingredientName, store: ingredientStore, shelf: ingredientShelf)
        
        let dishName:String = "Schnitzel mit Pommes";
        let dishRecipe:String="Kalbsfleisch panieren";
        addDish(dishName: dishName, dishRecipe: dishRecipe, ingredientNames: [ingredientName]);
        
        app.staticTexts[dishName].tap();

        XCTAssertEqual(app.staticTexts["dishNameText"].label, dishName);
        XCTAssertEqual(app.staticTexts["dishRecipeText"].label, dishRecipe);
        app.staticTexts["Show Ingredients"].tap();
        XCTAssertNotNil(app.staticTexts[ingredientName])
    }
    
    func testF_editDish()
    {
        let oldIngredientName:String = "Nudeln";
        let oldIngredientStore:String="Lidl";
        let oldIngredientShelf:Int16=6;
        addIngredient(name: oldIngredientName, store:oldIngredientStore, shelf:oldIngredientShelf);

        let newIngredientName:String = "Reis";
        let newIngredientStore:String="Lidl";
        let newIngredientShelf:Int16=3;
        addIngredient(name: newIngredientName, store:newIngredientStore, shelf:newIngredientShelf);
        
        let oldDishName:String = "Spaghetti mit Tomatensauce";
        let oldDishRecipe:String="Nudeln zubereiten";
        addDish(dishName: oldDishName, dishRecipe: oldDishRecipe, ingredientNames: [oldIngredientName]);
        
        app.staticTexts[oldDishName].tap();
        
        app.buttons["dishEditButton"].tap();

        let newDishName:String = "Curry";
        let newDishRecipe:String="Reis kochen";
        
        app.textFields["dishNameTextField"].tap();
        app.textFields["dishNameTextField"].clearAndEnterText(text:newDishName);
        
        app.textViews["recipeTextField"].tap();
        app.textViews["recipeTextField"].clearAndEnterText(text:newDishRecipe);

        app.staticTexts["Change Ingredients"].tap();
        app.buttons[oldIngredientName].tap();
        app.buttons[newIngredientName].tap();
        
        app.navigationBars.buttons.element(boundBy: 0).tap();
        
        app.buttons["dishDoneButton"].tap();

        XCTAssertEqual(app.staticTexts["dishNameText"].label, newDishName);
        XCTAssertEqual(app.staticTexts["dishRecipeText"].label, newDishRecipe);
        app.staticTexts["Show Ingredients"].tap();
        XCTAssertNotNil(app.staticTexts[newIngredientName]);
    }
    
    func testG_sortIngredientsByName()
    {
        let targetNames:[String]=["Birne", "Apfel", "Cola", "Nudeln"]
        
        for targetName in targetNames
        {
            addIngredient(name: targetName, store: "EDEKA", shelf: 1)
        }
        
        app.buttons["ingredientSortingSelectionButton"].tap();
        app.buttons["ingredientSortByNameButton"].tap();
        
        XCTAssertEqual(app.tables["ingredientList"].cells.allElementsBoundByIndex.map({return $0.label}), targetNames.sorted())
    }
    
    func testH_sortIngredientsByStore()
    {
        let targetStores:[String]=["EDEKA", "LIDL", "ALDI", "REWE"]
        
        for targetStore in targetStores
        {
            addIngredient(name: "Apfel", store: targetStore, shelf: 1)
        }
        
        app.buttons["ingredientSortingSelectionButton"].tap();
        app.buttons["ingredientSortByStoreButton"].tap();
        
        var currentStores:[String]=[];
        for cell in app.tables["ingredientList"].cells.allElementsBoundByIndex
        {
            cell.tap()
            currentStores.append(app.staticTexts["ingredientStoreText"].label)
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        XCTAssertEqual(currentStores, targetStores.sorted())
    }
    
    func testI_sortIngredientsByShelf()
    {
        let targetShelfs:[Int16]=[4, 1, 3, 8]
        
        for targetShelf in targetShelfs
        {
            addIngredient(name: "Apfel", store: "EDEKA", shelf: targetShelf)
        }
        
        app.buttons["ingredientSortingSelectionButton"].tap();
        app.buttons["ingredientSortByShelfButton"].tap();
        
        var currentShelfs:[Int16]=[];
        for cell in app.tables["ingredientList"].cells.allElementsBoundByIndex
        {
            cell.tap()
            currentShelfs.append(Int16(app.staticTexts["ingredientShelfText"].label)!)
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        XCTAssertEqual(currentShelfs, targetShelfs.sorted())
    }
    
    func testJ_sortDishesByName()
    {
        let targetNames:[String]=["Curry", "Apfelpfannkuchen", "Spaghetti mit Tomatensauce"];
        
        for targetName in targetNames
        {
            addDish(dishName: targetName, dishRecipe: "", ingredientNames: []);
        }
        
        app.buttons["dishSortingSelectionButton"].tap();
        app.buttons["dishSortByNameButton"].tap();
        
        XCTAssertEqual(app.tables["dishList"].cells.allElementsBoundByIndex.map({return $0.label}), targetNames.sorted())
    }
    
    func testK_sortDishesByNumberOfIngredients()
    {
        var ingredientsPerDish:OrderedDictionary<String, Array<String>> = [
            "Curry" : ["Reis"],
            "Apfelpfannkuchen" : ["Apfel", "Mehl"],
            "Spaghetti mit Tomatensauce" : []
        ];
         
        for dish in ingredientsPerDish.keys.elements
        {
            for ingredientName in ingredientsPerDish[dish]!
            {
                addIngredient(name: ingredientName, store: "EDEKA", shelf: 1)
            }
            
            addDish(dishName: dish, dishRecipe: "", ingredientNames: ingredientsPerDish[dish]!);
        }
        
        app.buttons["dishSortingSelectionButton"].tap();
        app.buttons["dishSortByNumberOfIngredientsButton"].tap();
        
        ingredientsPerDish.sort(by:{$0.value.count<$1.value.count});
        
        XCTAssertEqual(app.tables["dishList"].cells.allElementsBoundByIndex.map({return $0.label}), ingredientsPerDish.keys.elements);
    }
    
    func testL_createList()
    {
        createExampleShoppingList();
        
        var shoppingList:[String]=[];
        for cell in app.tables["shoppingListFinalList"].cells.allElementsBoundByIndex
        {
            shoppingList.append(cell.label)
        }
        
        XCTAssertEqual(shoppingList, ["Shelf 3", "Reis", "Shelf 5", "Curry", "Shelf 1", "Apfel", "Banane"])
    }
    
    func testM_createMarkdownList()
    {
        createExampleShoppingList();
        
        app.buttons["shoppingListShareButton"].tap();
        
        app.buttons["Copy"].tap()
        
        XCTAssertEqual(UIPasteboard.general.string ?? "No Value", "# EDEKA\n## Shelf 3\n- [ ] Reis\n\n## Shelf 5\n- [ ] Curry\n\n# LIDL\n## Shelf 1\n- [ ] Apfel\n- [ ] Banane\n\n");
    }
    
    private func createExampleShoppingList()->Void
    {
        addIngredient(name: "Apfel", store: "LIDL", shelf: 1);
        addIngredient(name: "Banane", store: "LIDL", shelf: 1);
        addIngredient(name: "Reis", store: "EDEKA", shelf: 3);
        addIngredient(name: "Curry", store: "EDEKA", shelf: 5);
        
        addDish(dishName: "Indischer Reis", dishRecipe: "", ingredientNames: ["Reis", "Curry"])
        
        app.tabBars.buttons.element(boundBy: 2).tap();
        
        app.tables["selectionList"].cells.element(boundBy: 0).tap()
        
        app.buttons["shoppingListChooseIngredientsButton"].tap();
        
        app.tables["selectionList"].cells.allElementsBoundByIndex.forEach(
            {
                if(["Apfel", "Banane"].contains($0.label))
                {
                    $0.tap();
                }
            }
        )
        
        app.buttons["shoppingListShowShoppingListButton"].tap();
    }
    

    private func addIngredient(name:String, store:String, shelf:Int16)
    {
        app.tabBars.buttons.element(boundBy: 1).tap();
        
        app.buttons["ingredientAddButton"].tap();
        
        app.textFields["ingredientNameTextField"].tap();
        app.textFields["ingredientNameTextField"].typeText(name)
        
        app.textFields["ingredientStoreTextField"].tap()
        app.textFields["ingredientStoreTextField"].typeText(store)
        
        app.setStepperValue(accessibilityIdentifier: "ingredientShelfStepper", currentValue: 1, targetValue: Int(shelf))
        
        app.buttons["ingredientDoneButton"].tap();
    }
    
    private func addDish(dishName:String, dishRecipe:String, ingredientNames:[String])
    {
        app.tabBars.buttons.element(boundBy: 0).tap();

        app.buttons["dishAddButton"].tap();

        app.textFields["dishNameTextField"].tap();
        app.textFields["dishNameTextField"].typeText(dishName);

        app.textViews["recipeTextField"].tap();
        app.textViews["recipeTextField"].typeText(dishRecipe);

        app.staticTexts["Change Ingredients"].tap();

        for ingredientName in ingredientNames
        {
            app.buttons[ingredientName].tap();
        }
        
        app.navigationBars.buttons.element(boundBy: 0).tap();
        app.buttons["dishDoneButton"].tap();
    }
}
