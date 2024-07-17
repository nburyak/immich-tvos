import Foundation

enum LoadingState<Type> {
    case loading
    case content(Type)
    case failure(Error)
}
