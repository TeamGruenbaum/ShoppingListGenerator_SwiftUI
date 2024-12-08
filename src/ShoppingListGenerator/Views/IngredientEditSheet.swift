import SwiftUI

struct IngredientEditSheet: View
{
    @State public var navigationTitle:String;
    public var cancelAction:(IngredientEditSheet)->Void;
    public var doneAction:()->Void;
    
    @Binding public var name:String;
    @Binding public var store:String;
    @Binding public var shelf:Int16;

    var body: some View
    {
        NavigationView
        {
            IngredientEditView(name:$name, store:$store, shelf:$shelf)
            .navigationBarItems(
                leading: Button("Cancel", action: {cancelAction(self)})
                .accentColor(Color(UIColor(named: "Secondary")!)),
                trailing: Button("Done", action: doneAction)
                .accessibilityIdentifier("ingredientDoneButton")
                .accentColor(Color(UIColor(named: "Secondary")!))
                .disabled(name.isEmpty || store.isEmpty)
            )
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
