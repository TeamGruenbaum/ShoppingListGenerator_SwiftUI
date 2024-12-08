import SwiftUI

struct DishDetailView: View
{
    @ObservedObject public var dish:Dish;

    var body: some View
    {
        VStack
        {
            Form
            {
                Section(header: Text("Name"))
                {
                    Text(dish.name ?? "NA")
                    .accessibilityIdentifier("dishNameText")
                    .animation(nil)
                    
                }
                
                Section(header: Text("Ingredients"))
                {
                    NavigationLink("Show Ingredients", destination:
                    {
                        VStack
                        {
                            List
                            {
                                ForEach(dish.ingredients?.allObjects as? [Ingredient] ?? [])
                                {ingredient in
                                    Text(ingredient.name ?? "NA");
                                }
                            }
                        }
                    }).accessibilityIdentifier("ingredientsListButton")
                }
                
                Section(header: Text("Recipe"))
                {
                    Text(dish.recipe ?? "NA")
                    .animation(nil)
                    .lineLimit(100)
                    .lineSpacing(7)
                    .frame(minHeight: 450, alignment: .topLeading)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .accessibilityIdentifier("dishRecipeText")
                }
            }
        }
    }
}

