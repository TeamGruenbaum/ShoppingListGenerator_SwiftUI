import SwiftUI



struct IngredientsView: View
{
    @ObservedObject var ingredientViewModel:IngredientViewModel;
    
    @State var addSheetActive:Bool=false;
    @State var editSheetActive:Bool=false;
    @State var showEditView:Bool=false;

    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach($ingredientViewModel.ingredients)
                {
                    $ingredient in
                    NavigationLink(ingredient.name ?? "No Value", destination:
                    {
                        IngredientDetailView(name: $ingredient.name ?? "NA", store: $ingredient.store ?? "NA", shelf: $ingredient.shelf)
                       .navigationBarItems(trailing: Button("Edit")
                        {
                            ingredientViewModel.setBackup(name: ingredient.name ?? "NA", store: ingredient.store ?? "NA", shelf: ingredient.shelf)
                            editSheetActive=true;
                        }.accessibilityIdentifier("ingredientEditButton"))
                        .sheet(isPresented: $editSheetActive, onDismiss: {}, content:
                        {
                            IngredientEditSheet(navigationTitle: "Edit Ingredient", cancelAction:
                                { sheet in
                                    ingredientViewModel.restoreBackup(name: &sheet.name, store: &sheet.store, shelf: &sheet.shelf);
                                    editSheetActive=false;
                                },
                                doneAction:
                                {
                                    ingredientViewModel.applyChanges();
                                    editSheetActive=false;
                                },
                                name: $ingredient.name ?? "NA", store: $ingredient.store ?? "NA", shelf: $ingredient.shelf)
                        })
                        .navigationBarTitleDisplayMode(.inline)
                    })
                }
                .onDelete(perform: ingredientViewModel.deleteIngredient);
            }
            .accessibilityIdentifier("ingredientList")
            .onAppear(perform:{UITableView.appearance().contentInset.top = 20})
            .navigationTitle("Ingredients")
            .navigationBarItems(
                trailing:
                HStack
                {
                    Menu(content:
                    {
                        Button(action: {ingredientViewModel.sortIngredients(orderType: IngredientsSortOrder.NAME)}, label: {Label("Name", systemImage: ingredientViewModel.currentSorting==IngredientsSortOrder.NAME ? "checkmark" : "")})
                        .accessibilityIdentifier("ingredientSortByNameButton")
                        
                        Button(action: {ingredientViewModel.sortIngredients(orderType: IngredientsSortOrder.STORE)}, label: {Label("Store", systemImage: ingredientViewModel.currentSorting==IngredientsSortOrder.STORE ? "checkmark" : "")})
                        .accessibilityIdentifier("ingredientSortByStoreButton")
                        
                        Button(action: {ingredientViewModel.sortIngredients(orderType: IngredientsSortOrder.SHELF)}, label: {Label("Shelf", systemImage: ingredientViewModel.currentSorting==IngredientsSortOrder.SHELF ? "checkmark" : "")})
                        .accessibilityIdentifier("ingredientSortByShelfButton")
                    },
                    label: {Label("Sort", systemImage: "arrow.up.arrow.down")})
                    .accessibilityIdentifier("ingredientSortingSelectionButton")
                    
                    Button(action:
                    {
                        addSheetActive=true
                    }, label: {Image(systemName: "plus").imageScale(.large)})
                    .accessibilityIdentifier("ingredientAddButton")
                    .foregroundColor(Color(UIColor(named: "Secondary")!))
                    .sheet(isPresented: $addSheetActive, onDismiss: {}, content:
                    {
                        IngredientEditSheet(navigationTitle: "New Ingredient", cancelAction:
                            { sheet in
                                addSheetActive=false;
                            },
                            doneAction:
                            {
                                ingredientViewModel.addIngredient();
                                addSheetActive=false;
                            },
                            name: $ingredientViewModel.newIngredientName, store: $ingredientViewModel.newIngredientStore, shelf: $ingredientViewModel.newIngredientShelf)
                    })
                }
            )
            .animation(.default)
        }
        .accentColor(Color(UIColor(named: "Secondary")!))
    }
}
