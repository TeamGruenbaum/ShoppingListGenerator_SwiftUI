import SwiftUI

struct IngredientDetailView: View
{
    @Binding public var name:String;
    @Binding public var store:String;
    @Binding public var shelf:Int16;

    var body: some View
    {
        VStack
        {
            Form
            {
                Section(header: Text("Name"))
                {
                    Text(name)
                    .accessibilityIdentifier("ingredientNameText")
                    .animation(nil)
                }
                
                Section(header: Text("Store"))
                {
                    Text(store)
                    .accessibilityIdentifier("ingredientStoreText")
                    .animation(nil)
                }
                
                Section(header: Text("Shelf"))
                {
                    Text(String(shelf))
                    .accessibilityIdentifier("ingredientShelfText")
                    .animation(nil)
                }
            }
        }
    }
}
