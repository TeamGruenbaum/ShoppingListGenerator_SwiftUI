import SwiftUI
import OrderedCollections

struct ShoppingListView: View
{
    @ObservedObject var dishViewModel:DishViewModel;
    @ObservedObject var ingredientViewModel:IngredientViewModel;
    
    @State var ingredientListActive:Bool=false;
    @State var shoppingListActive:Bool=false;
    

    var body: some View
    {
        NavigationView
        {
            VStack
            {
                SelectionList(items:$dishViewModel.dishes, navigationTitle: "Choose Dishes")
                .navigationBarItems(
                    trailing:
                    HStack
                    {
                        Menu(content:
                        {
                            Button(action: {dishViewModel.sortDishes(orderType: DishSortOrder.NAME)}, label: {Label("Name", systemImage: dishViewModel.currentSorting==DishSortOrder.NAME ? "checkmark" : "")})
                            
                            Button(action: {dishViewModel.sortDishes(orderType: DishSortOrder.INGREDIENTSCOUNT)}, label: {Label("Number of Ingredients", systemImage: dishViewModel.currentSorting==DishSortOrder.INGREDIENTSCOUNT ? "checkmark" : "")})
                        },
                        label: {Label("Sort", systemImage: "arrow.up.arrow.down")})

                        
                        Button(action:
                        {
                            ingredientViewModel.deselectIngredients();
                            dishViewModel.selectIngredientsBasedOnSelectedDishes(allIngredients: ingredientViewModel.ingredients)
                            ingredientListActive=true;
                        }, label: {Image(systemName: "chevron.forward").imageScale(.large)})
                        .accessibilityIdentifier("shoppingListChooseIngredientsButton")
                        .foregroundColor(Color(UIColor(named: "Secondary")!))
                    }
                )
                .background(
                Group
                {
                    if(ingredientListActive)
                    {
                        NavigationLink(destination:SelectionList(items:$ingredientViewModel.ingredients, navigationTitle: "Choose Ingredients")
                        .navigationBarItems(
                            trailing:
                            HStack
                            {
                                Menu(content:
                                {
                                    Button(action: {ingredientViewModel.sortIngredients(orderType: IngredientsSortOrder.NAME)}, label: {Label("Name", systemImage: ingredientViewModel.currentSorting==IngredientsSortOrder.NAME ? "checkmark" : "")})
                                    
                                    Button(action: {ingredientViewModel.sortIngredients(orderType: IngredientsSortOrder.STORE)}, label: {Label("Store", systemImage: ingredientViewModel.currentSorting==IngredientsSortOrder.STORE ? "checkmark" : "")})
                                    
                                    Button(action: {ingredientViewModel.sortIngredients(orderType: IngredientsSortOrder.SHELF)}, label: {Label("Shelf", systemImage: ingredientViewModel.currentSorting==IngredientsSortOrder.SHELF ? "checkmark" : "")})
                                },
                                label: {Label("Sort", systemImage: "arrow.up.arrow.down")})

                                
                                Button(action:
                                {
                                    shoppingListActive=true;
                                }, label: {Image(systemName: "chevron.forward").imageScale(.large)})
                                .accessibilityIdentifier("shoppingListShowShoppingListButton")
                                .foregroundColor(Color(UIColor(named: "Secondary")!))
                            }
                        ), isActive: $ingredientListActive, label: {Text("Choose Ingredient")})
                    }
                })
                .sheet(isPresented: $shoppingListActive, onDismiss: {}, content:
                {
                    NavigationView
                    {
                        List
                        {
                            ForEach(ingredientViewModel.shoppingList.keys, id: \.self)
                            { store in
                                
                                Section(header: Text(store))
                                {
                                    ForEach(ingredientViewModel.shoppingList[store]?.keys ?? OrderedSet<Int16>(), id: \.self)
                                    { shelf in
                                    
                                        Section(header: Text("Shelf \(shelf)").bold())
                                        {
                                        
                                            ForEach(ingredientViewModel.shoppingList[store]?[shelf] ?? [], id: \.self)
                                            { ingredient in
                                                SelectableListItem<String>(item: ingredient)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .accessibilityIdentifier("shoppingListFinalList")
                        .navigationTitle("Your ShoppingList")
                        .navigationBarItems(leading: Button("Done", action: {shoppingListActive=false}).foregroundColor(Color(UIColor(named: "Secondary")!)),
                        trailing:
                            Button(action:
                            {
                                if var topController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController
                                {
                                    while let presentedViewController = topController.presentedViewController
                                    {
                                        topController = presentedViewController
                                    }

                                    topController.present(UIActivityViewController(activityItems: [ingredientViewModel.shoppingListMarkdown], applicationActivities: nil), animated: true, completion: nil)
                                }
                            }, label: {Label("Share", systemImage: "square.and.arrow.up")})
                            .accessibilityIdentifier("shoppingListShareButton")
                            .foregroundColor(Color(UIColor(named: "Secondary")!))
                        )
                    }
                })
            }
        }
        .accentColor(Color(UIColor(named: "Secondary")!))
    }
}
