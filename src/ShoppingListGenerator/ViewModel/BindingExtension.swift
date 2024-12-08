import SwiftUI


func ??<T>(left: Binding<Optional<T>>, right: T) -> Binding<T>
{
    return Binding(
        get: { left.wrappedValue ?? right },
        set: { left.wrappedValue = $0 }
    )
}
