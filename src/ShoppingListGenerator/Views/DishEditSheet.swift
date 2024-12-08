import SwiftUI

struct DishEditSheet: View
{
    @State public var navigationTitle:String;
    public var cancelAction:(DishEditSheet)->Void;
    public var doneAction:()->Void;
    
    @Binding public var name:String;
    @Binding public var ingredients:[Ingredient];
    @Binding public var recipe:String;

    var body: some View
    {
        NavigationView
        {
            DishEditView(name: $name, ingredients: $ingredients, recipe: $recipe)
            .navigationBarItems(
                leading: Button("Cancel", action: {cancelAction(self)})
                .accentColor(Color(UIColor(named: "Secondary")!)),
                trailing: Button("Done", action: doneAction)
                    .accessibilityIdentifier("dishDoneButton")
                .accentColor(Color(UIColor(named: "Secondary")!))
                .disabled(name.isEmpty)
            )
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline);
        }
        .accentColor(Color(UIColor(named: "Secondary")!))
    }
}

