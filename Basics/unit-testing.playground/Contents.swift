import XCTest

// --- Testing mutating a model ---

extension Product {
    mutating func apply(_ coupon: Coupon) {
        let multiplier = 1 - coupon.discount / 100
        price *= multiplier
    }
}

class ProductTests: XCTestCase {
    func testApplyingCoupon() {
        // Given
        var product = Product(name: "Book", price: 25)
        let coupon = Coupon(name: "Holiday Sale", discount: 20)

        // When
        product.apply(coupon)

        // Then
        XCTAssertEqual(product.price, 20)
    }
}

// --- Using a test case's setUp method ---

class ShoppingCartTests: XCTestCase {
    private var shoppingCart: ShoppingCart!

    override func setUp() {
        super.setUp()
        shoppingCart = ShoppingCart()
    }

    func testCalculatingTotalPrice() {
        // Given
        XCTAssertEqual(shoppingCart.totalPrice, 0)

        // When
        shoppingCart.add(Product(name: "Book", price: 20))
        shoppingCart.add(Product(name: "Movie", price: 15))

        // Then
        XCTAssertEqual(shoppingCart.totalPrice, 35)
    }

    func testApplyingCouponToCart() {
        // Given
        shoppingCart.add(Product(name: "Book", price: 20))
        shoppingCart.add(Product(name: "Movie", price: 15))
        let coupon = Coupon(name: "Holiday Sale", discount: 20)
        
        // Logging
        print("Shopping cart before applying coupon:")
        for product in shoppingCart.getProducts() {
            print("\(product.name) - $\(product.price)")
        }
        print("Total price: $\(shoppingCart.totalPrice)")
        
        // When
        shoppingCart.apply(coupon)
        
        // Logging
        print("Shopping cart after applying coupon:")
        for product in shoppingCart.getProducts() {
            print("\(product.name) - $\(product.price)")
        }
        print("Total price: $\(shoppingCart.totalPrice)")
        
        // Then
        XCTAssertEqual(shoppingCart.totalPrice, 28)
    }
}

class ShoppingCart {
    private var products: [Product] = []

    func add(_ product: Product) {
        products.append(product)
    }

    func remove(_ product: Product) {
        if let index = products.firstIndex(of: product) {
            products.remove(at: index)
        }
    }

    var totalPrice: Double {
        products.reduce(0) { $0 + $1.price }
    }

    func apply(_ coupon: Coupon) {
        for index in products.indices {
            products[index].apply(coupon)
        }
    }
    func getProducts() -> [Product] {
        return products
    }
}

struct Product: Equatable {
    let name: String
    var price: Double
}

struct Coupon: Equatable {
    let name: String
    let discount: Double
}
// --- Running all of our unit tests within the playground ---
let testSuite = XCTestSuite.default
testSuite.run()
