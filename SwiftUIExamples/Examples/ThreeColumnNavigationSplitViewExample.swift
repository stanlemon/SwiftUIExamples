//
//  ThreeColumnNavigationSplitViewExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI

private var menus: [Item] = [
  .init(
    name: "Breakfast",
    children: [
      .init(name: "Pancakes", children: [.init(name: "Pancakes"), .init(name: "Maple Syrup")]),
      .init(name: "Scrambled Eggs", children: [.init(name: "Eggs"), .init(name: "Sausage"), .init(name: "Bacon"), .init(name: "Toast")])
    ]
  ),
  .init(
    name: "Second Breakfast"
  ),
  .init(
    name: "Lunch"
  ),
  .init(
    name: "Dinner"
  ),
]

struct ThreeColumnNavigationSplitViewExample: View {
  @State private var columnVisibility: NavigationSplitViewVisibility = .all
  @State private var meal: Item?
  @State private var menu: Item?

  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      List(menus, selection: $menu) { menu in
        NavigationLink(menu.name, value: menu)
      }
      .navigationTitle("Menus")
    } content: {
      if let menu {
        List(menu.children, selection: $meal) { meal in
          NavigationLink(meal.name, value: meal)
        }
        .navigationTitle(menu.name)
      } else {
        Text("Select a menu")
          .italic()
      }
    } detail: {
      if let meal {
        List(meal.children) { ingredient in
          Text(ingredient.name)
        }
        .navigationTitle("Ingredients")
      }
    }
  }
}

struct ThreeColumnNavigationSplitViewExample_Previews: PreviewProvider {
  static var previews: some View {
    ThreeColumnNavigationSplitViewExample()
      .previewInterfaceOrientation(.landscapeLeft)
      .previewDevice("iPad Air (5th generation)")
  }
}
