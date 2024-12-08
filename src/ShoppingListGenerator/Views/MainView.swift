import Foundation
import SwiftUI

struct MainView:View
{
    var dishViewModel:DishViewModel=DishViewModel();
    var ingredientViewModel:IngredientViewModel=IngredientViewModel();

    var body: some View
    {
        TabView()
        {
            DishView(dishViewModel: dishViewModel, ingredientViewModel: ingredientViewModel)
                .tabItem {
                    Label("Dishes", systemImage: "fork.knife")
            }
            
            IngredientsView(ingredientViewModel:ingredientViewModel)
            .tabItem {
                Label("Ingredients", systemImage: "leaf.fill")
            }
            
            ShoppingListView(dishViewModel: dishViewModel, ingredientViewModel: ingredientViewModel)
            .tabItem {
                Label("Shopping List", systemImage: "list.bullet.rectangle.fill")
            }
        }
        .accentColor(Color(UIColor(named: "Primary")!))
        .animation(nil)
    }
}
