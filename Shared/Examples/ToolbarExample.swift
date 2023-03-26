//
//  ToolbarExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/25/23.
//

import SwiftUI

private let TOOLBAR_IDENTIFIER = "toolbar_identifier"

private enum ToolbarSelection: String, CaseIterable, Identifiable {
  case bold, italic, underline, strikethrough
  var id: Self { self }
}

struct ToolbarExample: View {
  @State private var selections = [ToolbarSelection]()

  var body: some View {
    NavigationSplitView {
      Text("Sidebar")
        .navigationTitle("Sidebar")
    } detail: {
      VStack(alignment: .leading) {
        Text("Detail")
          .padding(.bottom)

        if !selections.isEmpty {
          Text("Selections: \(selections.map { $0.rawValue }.joined(separator: ", "))")
        }

        Spacer()
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .navigationTitle("Detail")
      .toolbarRole(.editor)
      .toolbar(id: TOOLBAR_IDENTIFIER) {
        buildToolbar()
      }
    }
  }

  // This works great on iPadOS, but it's glitchy on macOS and on iOS is showsByDefault is false the option will not be available at all in the overflow menu
  @ToolbarContentBuilder
  private func buildToolbar() -> some CustomizableToolbarContent {
    // Setting shows by default means the button will appear
    ToolbarItem(id: "bold_button", placement: .secondaryAction, showsByDefault: true) {
      Button {
        selections.toggle(.bold)
      } label: {
        Label("Bold", systemImage: "bold")
      }
    }

    ToolbarItem(id: "italic_button", placement: .secondaryAction, showsByDefault: true) {
      Button {
        selections.toggle(.italic)
      } label: {
        Label("Italic", systemImage: "italic")
      }
    }

    ToolbarItem(id: "underline_button", placement: .secondaryAction, showsByDefault: true) {
      Button {
        selections.toggle(.underline)
      } label: {
        Label("Underline", systemImage: "underline")
      }
    }

    // This item is hidden until the user configures it to be present
    ToolbarItem(id: "strikethrough_button", placement: .secondaryAction, showsByDefault: false) {
      Button {
        selections.toggle(.strikethrough)
      } label: {
        Label("Strikethrough", systemImage: "strikethrough")
      }
    }
  }
}

struct ToolbarExample_Previews: PreviewProvider {
  static var previews: some View {
    ToolbarExample()
      .previewInterfaceOrientation(.landscapeLeft)
      .previewDevice("iPad Air (5th generation)")
  }
}

private extension Array where Element == ToolbarSelection {
  mutating func toggle(_ element: Element) {
    if self.contains(element) {
      self.removeAll(where: { $0 == element })
    } else {
      self.append(element)
    }
  }
}
