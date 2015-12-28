//
//  CoArbitrary.swift
//  SwiftCheck
//
//  Created by Robert Widmann on 12/15/15.
//  Copyright © 2015 Robert Widmann. All rights reserved.
//

/// `CoArbitrary is the dual to the `Arbitrary` protocol.  Where `Arbitrary` allows generating
/// random values, `CoArbitrary` allows observance of random values passing through as input to 
/// random functions.  A `CoArbitrary` type is thus able to influence the flow of values in the
/// function.
///
/// `CoArbitrary` types must take an arbitrary value of their type and yield a function that
/// transforms a given generator by returning a new generator that depends on the input value.  Put
/// simply, the function should perturb the given generator (more than likely using `Gen.variant()`)
/// based on the value it observes.
public protocol CoArbitrary {
	/// Uses an instance of the receiver to return a function that perturbs a generator.
	static func coarbitrary<C>(x : Self) -> (Gen<C> -> Gen<C>)
}

extension IntegerType {
	/// A coarbitrary implementation for any IntegerType
	public func coarbitraryIntegral<C>() -> Gen<C> -> Gen<C> {
		return { $0.variant(self) }
	}
}

/// A coarbitrary implementation for any Printable type.  Avoid using this function if you can, it
/// can be quite an expensive operation given a detailed enough description.
public func coarbitraryPrintable<A, B>(x : A) -> Gen<B> -> Gen<B> {
	return String.coarbitrary(String(x))
}

extension Bool : CoArbitrary {
	public static func coarbitrary<C>(x : Bool) -> Gen<C> -> Gen<C> {
		return { g in
			if x {
				return g.variant(1)
			}
			return g.variant(0)
		}
	}
}

extension UnicodeScalar : CoArbitrary {
	public static func coarbitrary<C>(x : UnicodeScalar) -> Gen<C> -> Gen<C> {
		return UInt32.coarbitrary(x.value)
	}
}

extension Character : CoArbitrary {
	public static func coarbitrary<C>(x : Character) -> (Gen<C> -> Gen<C>) {
		let ss = String(x).unicodeScalars
		return UnicodeScalar.coarbitrary(ss[ss.startIndex])
	}
}

extension String : CoArbitrary {
	public static func coarbitrary<C>(x : String) -> (Gen<C> -> Gen<C>) {
		if x.isEmpty {
			return { $0.variant(0) }
		}
		return Character.coarbitrary(x[x.startIndex]) • String.coarbitrary(x[x.startIndex.successor()..<x.endIndex])
	}
}

extension Int : CoArbitrary {
	public static func coarbitrary<C>(x : Int) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension Int8 : CoArbitrary {
	public static func coarbitrary<C>(x : Int8) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension Int16 : CoArbitrary {
	public static func coarbitrary<C>(x : Int16) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension Int32 : CoArbitrary {
	public static func coarbitrary<C>(x : Int32) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension Int64 : CoArbitrary {
	public static func coarbitrary<C>(x : Int64) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension UInt : CoArbitrary {
	public static func coarbitrary<C>(x : UInt) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension UInt8 : CoArbitrary {
	public static func coarbitrary<C>(x : UInt8) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension UInt16 : CoArbitrary {
	public static func coarbitrary<C>(x : UInt16) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension UInt32 : CoArbitrary {
	public static func coarbitrary<C>(x : UInt32) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

extension UInt64 : CoArbitrary {
	public static func coarbitrary<C>(x : UInt64) -> Gen<C> -> Gen<C> {
		return x.coarbitraryIntegral()
	}
}

// In future, implement these with Ratios like QuickCheck.
extension Float : CoArbitrary {
	public static func coarbitrary<C>(x : Float) -> (Gen<C> -> Gen<C>) {
		return Int64(x).coarbitraryIntegral()
	}
}

extension Double : CoArbitrary {
	public static func coarbitrary<C>(x : Double) -> (Gen<C> -> Gen<C>) {
		return Int64(x).coarbitraryIntegral()
	}
}

extension Array : CoArbitrary {
	public static func coarbitrary<C>(a : [Element]) -> (Gen<C> -> Gen<C>) {
		if a.isEmpty {
			return { $0.variant(0) }
		}
		return { $0.variant(1) } • [Element].coarbitrary([Element](a[1..<a.endIndex]))
	}
}

extension Dictionary : CoArbitrary {
	public static func coarbitrary<C>(x : Dictionary<Key, Value>) -> (Gen<C> -> Gen<C>) {
		if x.isEmpty {
			return { $0.variant(0) }
		}
		return { $0.variant(1) }
	}
}

extension Optional : CoArbitrary {
	public static func coarbitrary<C>(x : Optional<Wrapped>) -> (Gen<C> -> Gen<C>) {
		if let _ = x {
			return { $0.variant(0) }
		}
		return { $0.variant(1) }
	}
}

extension Set : CoArbitrary {
	public static func coarbitrary<C>(x : Set<Element>) -> (Gen<C> -> Gen<C>) {
		if x.isEmpty {
			return { $0.variant(0) }
		}
		return { $0.variant(1) }
	}
}
