import SwiftUI

@main
struct ShoppingListGeneratorApp: App
{
    init()
    {
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance();
        
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground();
        appearance.backgroundColor = UIColor(named: "Primary")!;
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Secondary")!]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "Secondary")!]
        appearance.backButtonAppearance.normal.titleTextAttributes=[.foregroundColor: UIColor(named: "Secondary")!]
                
        //appearance.
        
        // to make everything work normally
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal);
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal);
    }
    
    var body: some Scene
    {
        WindowGroup
        {
            MainView()
        }
    }
}
