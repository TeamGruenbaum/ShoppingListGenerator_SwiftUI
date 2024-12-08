import SwiftUI

struct IngredientEditView: View
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
                    TextField("Name of the ingredient", text:$name)
                    .accessibilityIdentifier("ingredientNameTextField")
                    .disableAutocorrection(true)
                }
                
                Section(header: Text("Store"))
                {
                    TextField("Store of the ingredient", text:$store)
                    .accessibilityIdentifier("ingredientStoreTextField")
                    .disableAutocorrection(true)
                }
                
                Section(header: Text("Shelf"))
                {
                    HStack
                    {
                        Text(String(shelf))
                        Spacer()
                        Stepper("", value: $shelf, in: 1...20)
                            .accessibilityIdentifier("ingredientShelfStepper")
                            .frame(width: 100, height: 35)
                            .offset(x: -4)
                            .background(Color(UIColor(named: "Primary")!))
                            .accentColor(Color(UIColor(named: "Secondary")!))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
