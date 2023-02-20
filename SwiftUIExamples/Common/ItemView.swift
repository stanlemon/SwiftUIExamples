//
//  ItemView.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI

// Display an item
struct ItemView: View {
  var item: Item

  var body: some View {
    VStack(alignment: .leading) {
      if !item.description.isEmpty {
        Text(item.description)
          .padding(.bottom)
      }
      if !item.tags.isEmpty {
        Text("**Tags:** \(item.tags.joined(separator: ", "))")
          .padding(.bottom)
      }
      Text("Created at \(item.created)")
        .padding(.bottom)

      if !item.children.isEmpty {
        ForEach(item.children) { child in
          NavigationLink(child.name, value: child)
        }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .navigationTitle(item.name)
  }
}

struct ItemView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ItemView(item: items[1])
    }
  }
}
