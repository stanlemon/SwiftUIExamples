//
//  Item.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import Foundation

// Generic structure for items
struct Item: Identifiable, Hashable {
  var id: UUID = UUID()
  var name: String
  var description = ""
  var created = Date()
  var tags = [String]()
  var children = [Item]()
}

// Items one through ten
var items: [Item] = [
  .init(
    name: "One",
    description: "One is the loneliest number that you'll ever do.",
    tags: ["positive", "odd"],
    children: [.init(name: "One point one"), .init(name: "One point two")]
  ),
  .init(
    name: "Two",
    description: "Two can be as bad as one. It's the loneliest number since the number one.",
    tags: ["positive", "prime", "even"],
    children: [.init(name: "Two point one"), .init(name: "Two point two")]
  ),
  .init(name: "Three"),
  .init(name: "Four"),
  .init(name: "Five"),
  .init(name: "Six"),
  .init(name: "Seven"),
  .init(name: "Eight"),
  .init(name: "Nine"),
  .init(name: "Ten"),
]

// The colors of the rainbow
var colors: [Item] = [
  .init(name: "Red", tags: ["primary", "redish"]),
  .init(name: "Orange", tags: ["secondary", "redish", "yellowish"]),
  .init(name: "Yellow", tags: ["primary", "yellowish"]),
  .init(name: "Green", tags: ["secondary", "yellowish", "blueish"]),
  .init(name: "Blue", tags: ["primary", "blueish"]),
  .init(name: "Indigo", tags: ["secondary", "blueish"]),
  .init(name: "Violet", tags: ["secondary", "blueish"]),
]
