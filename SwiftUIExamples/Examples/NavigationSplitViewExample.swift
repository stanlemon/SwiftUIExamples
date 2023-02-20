//
//  NavigationSplitViewExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI

struct TwoColumnNavigationSplitViewExample: View {
  @State private var columnVisibility: NavigationSplitViewVisibility = .all
  @State private var selection: Item?
  @State private var path = NavigationPath()

  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      List(items, selection: $selection) { item in
        NavigationLink(item.name, value: item)
      }
    } detail: {
      NavigationStack(path: $path) {
        VStack {
          if let selection {
            ItemView(item: selection)
          } else {
            Text("Select an item")
              .italic()
          }
        }
        .navigationDestination(for: Item.self) { item in
          ItemView(item: item)
        }
      }
    }
  }
}

struct NavigationSplitViewExample_Previews: PreviewProvider {
  static var previews: some View {
    TwoColumnNavigationSplitViewExample()
      .previewInterfaceOrientation(.landscapeLeft)
      .previewDevice("iPad Air (5th generation)")
  }
}
