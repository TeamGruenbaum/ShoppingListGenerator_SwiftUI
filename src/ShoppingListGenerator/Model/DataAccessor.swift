protocol DataAccessor
{
    associatedtype T
    
    func getAllElements()->[T];
    func getEmptyElement()->T;
    func deleteElement(element:T)->Void
    func applyChanges()->Void
}
