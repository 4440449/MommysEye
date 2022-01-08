
import Foundation


//protocol Observable {
//    associatedtype V
//    func subscribe(observer: AnyObject, callback: @escaping (V) -> ())
//    func unsubscribe(observer: AnyObject)
//}


public final class Publisher<V> { //: Observable {
   
    struct Observer<T> {
        weak var observer: AnyObject?
        let callback: (T) -> ()
        
        init(_ observer: AnyObject?, _ callback: @escaping (T) -> () ) {
            self.callback = callback
            self.observer = observer
        }
    }
    
    public var value: V { didSet { notify() } }
    private var observers = [Observer<V>]()
    
    public init(value: V) {
        self.value = value
    }
    
    public func notify() {
        DispatchQueue.main.async {
            self.observers.forEach { $0.callback(self.value) }
        }
    }
    
    
    public func subscribe(observer: AnyObject, callback: @escaping (V) -> ()) {
        observers.append(Observer(observer, callback))
    }
    
    public func unsubscribe(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    deinit {
        print("Publisher is deinit")
    }
    
}

