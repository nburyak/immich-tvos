import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T?
    let userDefaults: UserDefaults = .standard

    var wrappedValue: T? {
        get {
            return userDefaults.object(forKey: key) as? T
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
