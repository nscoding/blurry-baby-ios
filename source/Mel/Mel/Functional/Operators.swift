//
//  Operators.swift
//  SongBattles
//
//  Created by Kostas Kremizas on 23/8/19.
//  Copyright © 2019 kremizas. All rights reserved.
//

import Foundation

// MARK: ForwardApplication

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

// MARK: ForwardComposition

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in
        g(f(a))
    }
}

// MARK: BackwardsComposition

precedencegroup BackwardsComposition {
    associativity: left
}

infix operator <<<: BackwardsComposition

func <<< <A, B, C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> (A) -> C {
    return { x in
        g(f(x))
    }
}

// MARK: EffectfulComposition (flatMap)

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
) -> ((A) -> C?) {
    
    return { a in f(a).flatMap(g) }
}

func >=> <A, B, C>(
    _ f: @escaping (A) -> [B],
    _ g: @escaping (B) -> [C]
) -> ((A) -> [C]) {
    
    return { a in f(a).flatMap(g) }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { a in { b in f(a, b) } }
}

func uncurry<A, B, C>(_ f: @escaping ((A) -> (B) -> C)) -> (A, B) -> C {
    { a, b in f(a)(b) }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    { a in { b in { c in f(a, b, c) } }}
}

func uncurry<A, B, C, D>(_ f: @escaping (A) -> (B) -> (C) -> D) -> (A, B, C) -> D {
    { a, b, c in f(a)(b)(c) }
}

func curry<A, B, C, D, E>(_ f: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    { a in { b in { c in { d in f(a, b, c, d) } } } }
}


func uncurry<A, B, C, D, E>(_ f: @escaping (A) -> (B) -> (C) -> (D) -> E) -> (A, B, C, D) -> E {
    { a, b, c, d in f(a)(b)(c)(d) }
}

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    { b in { a in f(a)(b) } }
}

func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {
    { { a in f(a)() } }
}

func zurry<A>(_ f: () -> A) -> A {
    return f()
}

func map<Element>(_ f: @escaping (Element) -> Element) -> (Element?) -> Element? {
    return { optional in
        return optional.map(f)
    }
}
