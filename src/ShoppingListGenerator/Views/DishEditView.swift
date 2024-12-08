import SwiftUI
import Foundation

struct DishEditView: View
{
    @Binding public var name:String;
    @Binding public var ingredients:[Ingredient];
    @Binding public var recipe:String;
    

    var body: some View
    {
        VStack
        {
            Form
            {
                Section(header: Text("Name"))
                {
                    TextField("Name of the dish", text:$name)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("dishNameTextField")
                }
                
                Section(header: Text("Ingredients"))
                {
                    NavigationLink("Change Ingredients", destination: {SelectionList(items: $ingredients, navigationTitle: "Change Ingredients")})
                        .accessibilityIdentifier("ingredientsSelectButton")
                }
                
                Section(header: Text("Recipe"))
                {
                    TextEditor(text: $recipe)
                    .disableAutocorrection(true)
                    .lineLimit(100)
                    .lineSpacing(7)
                    .frame(minHeight: 450)
                    .accessibilityIdentifier("recipeTextField");
                }
            }
        }
    }
}
