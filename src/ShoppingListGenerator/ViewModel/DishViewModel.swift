import Combine
import Foundation
import SwiftUI

class DishViewModel:ObservableObject
{
    @Published internal var dishes:[Dish]
    
    @Published internal var newDishName:String;
    @Published internal var newDishRecipe:String;
        
    private var backupName:String="";
    private var backupRecipe:String="";
    
    @Published internal var currentSorting:DishSortOrder
    
    
    internal init()
    {
        dishes=DishDataAccessor.instance.getAllElements();
    
        newDishName="";
        newDishRecipe="";
        
        currentSorting=DishSortOrder.NAME;
    }
    
    internal func addDish(allIngredients:[Ingredient])->Void
    {
        let newDish:Dish=DishDataAccessor.instance.getEmptyElement();
        
        newDish.id=UUID();
        newDish.name=newDishName;
        newDish.recipe=newDishRecipe;

        setIngredientsForDish(dish: newDish, allIngredients: allIngredients);
        dishes.append(newDish)
        
        newDishName="";
        newDishRecipe="";
    }
    
    internal func sortDishes()
    {
        sortDishes(orderType: currentSorting);
    }
    
    internal func sortDishes(orderType:DishSortOrder)
    {
        currentSorting=orderType;
    
        switch(orderType)
        {
            case .NAME: dishes.sort(by: {$0.name! < $1.name!}); break;
            case .INGREDIENTSCOUNT: dishes.sort(by: {$0.ingredients?.count ?? 0 < $1.ingredients?.count ?? 0}); break;
        }
    }
    
    internal func setIngredientsForDish(dish:Dish, allIngredients:[Ingredient])->Void
    {
        dish.removeFromIngredients(dish.ingredients ?? NSSet())
    
        var selectedIngredients:[Ingredient]=[];
        dish.ingredients=[];
        
        allIngredients.forEach(
        {ingredient in
            if(ingredient.isSelected)
            {
                selectedIngredients.append(ingredient);
            }
        })
        
        dish.addToIngredients(NSSet(array: selectedIngredients));
    }
    
    internal func selectIngredientsBasedOnDish(dish:Dish, allIngredients:[Ingredient])->Void
    {
        let ingredientsFromDish:[Ingredient]=dish.ingredients?.allObjects as? [Ingredient] ?? [];
    
        for selectedIngredient in ingredientsFromDish
        {
            for ingredient in allIngredients
            {
                if(ingredient.id==selectedIngredient.id)
                {
                    ingredient.isSelected=true;
                }
            }
        }
    }
    
    internal func selectIngredientsBasedOnSelectedDishes(allIngredients:[Ingredient])->Void
    {
        var ingredientsFromSelectedDishes:[Ingredient]=[];
        
        for dish in dishes 
        {
            if(dish.isSelected)
            {
                ingredientsFromSelectedDishes.append(contentsOf: dish.ingredients?.allObjects as? [Ingredient] ?? []);
            }
        }
        
        for selectedIngredient in ingredientsFromSelectedDishes
        {
            for ingredient in allIngredients
            {
                if(ingredient.id==selectedIngredient.id)
                {
                    if(!ingredient.isSelected)
                    {
                        ingredient.isSelected=true;
                    }
                    break;
                }
            }
        }
    }
    
    internal func setBackup(name:String, recipe: String)->Void
    {
        backupName=name;
        backupRecipe=recipe;
    }
    
    internal func restoreBackup(name:inout String, recipe:inout String)->Void
    {
        name=backupName
        recipe=backupRecipe;
    }
    
    internal func deleteDishes(indices: IndexSet)->Void
    {
        for index in indices
        {
            DishDataAccessor.instance.deleteElement(element:dishes[index]);
        }
        IngredientDataAccessor.instance.applyChanges();
        
        dishes.remove(atOffsets: indices);
    }
    
    internal func applyChanges()->Void
    {
        DishDataAccessor.instance.applyChanges();
    }
}
