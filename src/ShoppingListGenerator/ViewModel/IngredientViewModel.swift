import Combine
import Foundation
import OrderedCollections

class IngredientViewModel:ObservableObject
{
    @Published internal var ingredients:[Ingredient]
    
    @Published internal var newIngredientName:String;
    @Published internal var newIngredientStore:String;
    @Published internal var newIngredientShelf:Int16;
    
    private var backupName:String="";
    private var backupStore:String="";
    private var backupShelf:Int16=1;
    
    @Published internal var currentSorting:IngredientsSortOrder;
    
    internal var shoppingList:OrderedDictionary<String, OrderedDictionary<Int16, [String]>>
    {
        get
        {
            let copiedIngredients:[Ingredient]=ingredients.filter({$0.isSelected});
        
            var result:OrderedDictionary<String, OrderedDictionary<Int16, [String]>> = [:]
        
            copiedIngredients.forEach(
            { ingredient in
            
                if(!result.keys.contains(ingredient.store!))
                {
                    result[ingredient.store!]=[:];
                }
                
                if(!result[ingredient.store!]!.keys.contains(ingredient.shelf))
                {
                    result[ingredient.store!]![ingredient.shelf]=[];
                }
            
                result[ingredient.store!]?[ingredient.shelf]?.append(ingredient.name!);
            })
        
            result.sort()
            
            for store in result.keys
            {
                result[store]?.sort();
                
                for shelf in result[store]!.keys
                {
                    result[store]![shelf]!.sort();
                }
            }
        
            return result;
        }
    }
    
    internal var shoppingListMarkdown:String
    {
        let shoppingList:OrderedDictionary<String, OrderedDictionary<Int16, [String]>>=shoppingList;
        var result="";


        for store in shoppingList.keys
        {
            result += "# \(store)";

            for shelf in shoppingList[store]?.keys ?? OrderedSet<Int16>()
            {
                result += "\n## Shelf \(shelf)";

                for ingredient in shoppingList[store]?[shelf] ?? []
                {
                    result += "\n- [ ] \(ingredient)";
                }
                
                result += "\n";
            }
            
            result += "\n";
        }
        
        return result;
    }
    
    
    internal init()
    {
        ingredients=IngredientDataAccessor.instance.getAllElements();
        
        newIngredientName="";
        newIngredientStore="";
        newIngredientShelf=1;
        
        currentSorting=IngredientsSortOrder.NAME;
        ingredients.sort(by: {$0.name! < $1.name!});
    }


    internal func addIngredient()->Void
    {
        let newIngredient:Ingredient=IngredientDataAccessor.instance.getEmptyElement();
        newIngredient.id=UUID();
        newIngredient.name=newIngredientName;
        newIngredient.store=newIngredientStore;
        newIngredient.shelf=newIngredientShelf;
        
        IngredientDataAccessor.instance.applyChanges();
        ingredients.append(newIngredient);
        
        sortIngredients(orderType: currentSorting)
        
        newIngredientName="";
        newIngredientStore="";
        newIngredientShelf=1;
    }
    
    internal func sortIngredients(orderType:IngredientsSortOrder)
    {
        currentSorting=orderType;
    
        switch(orderType)
        {
            case .NAME: ingredients.sort(by: {$0.name! < $1.name!}); break;
            case .STORE: ingredients.sort(by: {$0.store! < $1.store!}); break;
            case .SHELF: ingredients.sort(by: {$0.shelf < $1.shelf}); break;
            default: break;
        }
    }
    
    internal func setBackup(name:String, store: String, shelf: Int16)
    {
        backupName=name;
        backupStore=store;
        backupShelf=shelf;
    }
    
    internal func restoreBackup(name:inout String, store: inout String, shelf: inout Int16)
    {
        name=backupName;
        store=backupStore;
        shelf=backupShelf;
    }
    
    internal func deleteIngredient(indices: IndexSet)->Void
    {
        for index in indices
        {
            IngredientDataAccessor.instance.deleteElement(element:ingredients[index]);
        }
        IngredientDataAccessor.instance.applyChanges();
        
        ingredients.remove(atOffsets: indices);
    }
    
    
    internal func deselectIngredients()->Void
    {
        ingredients.forEach({$0.isSelected=false});
    }
    
    internal func applyChanges()->Void
    {
        IngredientDataAccessor.instance.applyChanges();
    }
}
