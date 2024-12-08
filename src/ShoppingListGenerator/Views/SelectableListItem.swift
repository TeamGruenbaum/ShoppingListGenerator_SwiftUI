import SwiftUI;

struct SelectableListItem<RowContentType: Printable>:View
{
    var item:RowContentType
    @State var isSelected:Bool=false;

    var body: some View
    {
        Button(action: {isSelected.toggle()})
        {
            HStack
            {
                Text(item.content)
                
                if isSelected
                {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
            .foregroundColor(.black)
        }
    }
}
