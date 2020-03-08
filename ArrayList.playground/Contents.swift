import Foundation

//重载运算符
extension Int {
    //前++
    static prefix  func ++(num:inout Int) -> Int  {
        num += 1
        return num
    }
    //后++
    static postfix  func ++(num:inout Int) -> Int  {
        let temp = num
        num += 1
        return temp
    }
    //前--
    static prefix  func --(num:inout Int) -> Int  {
        num -= 1
        return num
    }
    //后--
    static postfix  func --(num:inout Int) -> Int  {
        let temp = num
        num -= 1
        return temp
    }
}

enum SomeError: Error {
    case outOfBounds(String)
    case outOfMemory
}

private let DEFAULT_CAPACITY: Int = 10
private let ELEMENT_NOT_FOUND = -1

public class ArrayList {
    /// 元素的数量
    private var size: Int = 0
    /// 所有的元素
    private var elements: UnsafeMutablePointer<Int>
    
    init(_ capacity: Int = DEFAULT_CAPACITY) {
        let realCapacity = capacity < DEFAULT_CAPACITY ? DEFAULT_CAPACITY : capacity
        elements = UnsafeMutablePointer<Int>.allocate(capacity: realCapacity)
//        let pointer = calloc(realCapacity, MemoryLayout.size(ofValue: AnyObject.self))
//        elements = unsafeBitCast(pointer, to: NSArray.self)
    }
//    convenience init() {
//        self.init(DEFAULT_CAPACITY)
//    }
    
    private func rangeCheck(index: Int) {
        if index < 0 || index >= size {
            do {
                try outOfBounds(index: index)
            } catch let SomeError.outOfBounds(msg) {
                print(msg)
            } catch SomeError.outOfMemory {
                print("内存泄漏")
            } catch {
                print("其他错误")
            }
        }
    }
    
    private func rangeCheckForAdd(index: Int) {
        if index < 0 || index > size {
            do {
                try outOfBounds(index: index)
            } catch let SomeError.outOfBounds(msg) {
                print(msg)
            } catch SomeError.outOfMemory {
                print("内存泄漏")
            } catch {
                print("其他错误")
            }
        }
    }
    
    private func outOfBounds(index: Int) throws {
        throw SomeError.outOfBounds("Index = \(index), Size = \(size)")
    }
    
    public func toString() -> String {
        var str = "size = \(size), ["
        for i in 0..<size {
            if i > 0 {
                str.append(", ")
            }
            str.append("\(elements[i])")
        }
        str.append("]")
        return str
    }
    
    public func clear() {
        size = 0
    }
    
    public func length() -> Int {
        return size
    }
    
    public func isEmpty() -> Bool {
        size == 0
    }
    
    public func contains(_ element: Int) -> Bool {
        return indexOf(element) != ELEMENT_NOT_FOUND
    }
    
    public func add(_ element: Int) {
        insert(size, element)
    }
    
    public func insert(_ index: Int, _ element: Int) {
        rangeCheckForAdd(index: index)
        for i in size-1...index {
            elements[i+1] = elements[i]
        }
        elements[index] = element
        size++
    }
    
    /// 获取index位置的元素
    /// - Parameter index: index
    public func getElementOf(_ index: Int) -> Int {
        rangeCheck(index: index)
        return elements[index]
    }
    
    /// 设置index位置的元素
    /// - Parameters:
    ///   - index: index
    ///   - element: element
    public func set(_ index: Int, _ element: Int) -> Int {
        rangeCheck(index: index)
        let old = elements[index]
        elements[index] = element
        return old
    }
    
    /// 删除index位置的元素
    /// - Parameter index: index
    public func removeAt(_ index: Int) -> Int {
        rangeCheck(index: index)
        let old = elements[index]
        for i in (index+1)..<size {
            elements[i-1] = elements[i]
        }
        size--
        return old
    }
    
    /// 查看元素索引
    /// - Parameter element: element
    public func indexOf(_ element: Int) -> Int {
        for i in 0..<size {
            if elements[i] == element {
                return i
            }
        }
        return ELEMENT_NOT_FOUND
    }
}

let list = ArrayList()
list.add(3)
list.add(5)
list.getElementOf(-1)
list.removeAt(0)
print("\(list.toString())")
list.insert(0, 100)
print("\(list.toString())")
list.set(1, 90)
assert(list.getElementOf(1) == 90, "测试未通过")


