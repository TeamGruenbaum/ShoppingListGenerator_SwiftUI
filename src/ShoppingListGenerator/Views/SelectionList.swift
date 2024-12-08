import SwiftUI
import Foundation

struct SelectionList<Item: Printable & Selectable & Identifiable>: View
{
    @Binding var items:[Item];
    var navigationTitle:String;

    var body: some View
    {
        VStack
        {
            List
            {
                ForEach($items)
                { item in
                    SavingSelectableListItem(item: item)
                }
            }
            .accessibilityIdentifier("selectionList")
            .navigationTitle(navigationTitle)
            .onAppear(perform:{UITableView.appearance().contentInset.top = 20})
        }
    }
}
