import SwiftUI;

struct SavingSelectableListItem<RowContentType: Printable & Selectable & Identifiable>:View
{
    @Binding var item:RowContentType

    var body: some View
    {
        Button(action: {self.item.isSelected.toggle()})
        {
            HStack
            {
                Text(item.content)
                
                if item.isSelected
                {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
            .foregroundColor(.black)
        }
    }
}
