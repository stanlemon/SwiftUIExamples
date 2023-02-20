//
//  TableExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI

// An example of a table with navigation
struct TableExample: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @State private var path = NavigationPath()
  @State private var sortOrder = [KeyPathComparator(\Item.name)]
  @State private var selection: Item.ID?
  // Switching to multiple selections breaks the NavigationLink
  //@State private var selection: Set<Item.ID> = []

  var body: some View {
    NavigationStack(path: $path) {
      // The navigation modifiers cannot be on Table before 16.4 otherwise the compiler does not know what to do
      VStack {
        Table(items, selection: $selection, sortOrder: $sortOrder) {
          TableColumn("ID") { item in
            // For example, if this an iPhone the first column is the only one shown
            if horizontalSizeClass == .compact {
              VStack(alignment: .leading, spacing: 0) {
                NavigationLink(item.name, value: item)
                Text(item.description)
              }
            } else {
              Text(item.id.uuidString)
            }
          }
          // Specifying a value make the column sortable
          TableColumn("Name", value: \.name) { item in
            NavigationLink(item.name, value: item)
          }
          TableColumn("Description", value: \.description)
          TableColumn("Created", value: \.created) { item in
            Text(item.created.formatted())
          }
        }
      }
      // When the sort order changes
      .onChange(of: sortOrder) { newOrder in
        items.sort(using: newOrder)
      }
      .navigationDestination(for: Item.self) { item in
        ItemView(item: item)
      }
      .navigationTitle("Items")
    }
  }
}

struct TableExample_Previews: PreviewProvider {
  static var previews: some View {
    TableExample()
  }
}
