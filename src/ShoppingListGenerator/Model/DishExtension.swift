extension Dish:Selectable, Printable, Identifiable
{
    var content: String
    {
        return self.name ?? "NA"
    }
}
