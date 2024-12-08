import SwiftUI



struct DishView: View
{
    @ObservedObject var dishViewModel:DishViewModel;
    @ObservedObject var ingredientViewModel:IngredientViewModel;
    
    @State var editSheetActive:Bool=false;
    @State var addSheetActive:Bool=false;

    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach($dishViewModel.dishes)
                {
                    $dish in
                    NavigationLink(dish.name ?? "No Value", destination:
                    {
                        DishDetailView(dish: dish)
                       .navigationBarItems(trailing: Button("Edit", action:
                        {
                            dishViewModel.setBackup(name: dish.name ?? "NA", recipe: dish.recipe ?? "NA");
                            editSheetActive=true;
                       }).accessibilityIdentifier("dishEditButton"))
                        .sheet(isPresented: $editSheetActive, onDismiss: {}, content:
                        {
                            DishEditSheet(navigationTitle: "Edit Dish", cancelAction:
                                {sheet in
                                    dishViewModel.restoreBackup(name: &sheet.name, recipe: &sheet.recipe)
                                    
                                    editSheetActive=false;
                                },
                                doneAction:
                                {
                                    dishViewModel.setIngredientsForDish(dish: dish, allIngredients: ingredientViewModel.ingredients);
                                    dishViewModel.applyChanges();
                                    dishViewModel.sortDishes();
                                    
                                    editSheetActive=false;
                                },
                                name: $dish.name ?? "NA", ingredients: $ingredientViewModel.ingredients, recipe: $dish.recipe ?? "NA")
                        })
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear(perform:
                        {
                            ingredientViewModel.deselectIngredients();
                            dishViewModel.selectIngredientsBasedOnDish(dish: dish, allIngredients: ingredientViewModel.ingredients)
                        })
                    })
                }
                .onDelete(perform: dishViewModel.deleteDishes);
            }
            .accessibilityIdentifier("dishList")
            .onAppear(perform:{UITableView.appearance().contentInset.top = 20})
            .navigationTitle("Dishes")
            .navigationBarItems(
                trailing:
                HStack
                {
                    Menu(content:
                    {
                        Button(action: {dishViewModel.sortDishes(orderType: DishSortOrder.NAME)}, label: {Label("Name", systemImage: dishViewModel.currentSorting==DishSortOrder.NAME ? "checkmark" : "")})
                        .accessibilityIdentifier("dishSortByNameButton")
                        
                        Button(action: {dishViewModel.sortDishes(orderType: DishSortOrder.INGREDIENTSCOUNT)}, label: {Label("Number of Ingredients", systemImage: dishViewModel.currentSorting==DishSortOrder.INGREDIENTSCOUNT ? "checkmark" : "")})
                        .accessibilityIdentifier("dishSortByNumberOfIngredientsButton")
                    },
                    label: {Label("Sort", systemImage: "arrow.up.arrow.down")})
                    .accessibilityIdentifier("dishSortingSelectionButton")
                
                    Button(action:
                    {
                        addSheetActive=true
                        ingredientViewModel.deselectIngredients();
                    }, label: {Image(systemName: "plus").imageScale(.large)})
                    .accessibilityIdentifier("dishAddButton")
                    .foregroundColor(Color(UIColor(named: "Secondary")!))
                    .sheet(isPresented: $addSheetActive, onDismiss: {}, content:
                    {
                        DishEditSheet(navigationTitle: "New Dish", cancelAction:
                            { sheet in
                                addSheetActive=false;
                            },
                            doneAction:
                            {
                                dishViewModel.addDish(allIngredients: ingredientViewModel.ingredients);
                                dishViewModel.applyChanges();
                                addSheetActive=false;
                                dishViewModel.sortDishes();
                            },
                            name: $dishViewModel.newDishName, ingredients: $ingredientViewModel.ingredients, recipe: $dishViewModel.newDishRecipe)
                    })
                }
            )
            .animation(.default)
        }
        .accentColor(Color(UIColor(named: "Secondary")!))
    }
}
