//
//  SearchExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI

// An example of a list that can be searched with tokens and scopes
struct SearchExample: View {
  enum Token: String, Identifiable, CaseIterable {
    var id: String { return self.rawValue }

    case redish, yellowish, blueish
  }

  enum Scope: String {
    case all, primary, secondary
  }

  @State private var text = ""
  @State private var scope: Scope = .all
  @State private var tokens = [Token]()

  // Results of the color list after it has been filtered
  var results: [Item] {
    var colors = colors

    if !text.isEmpty {
      colors = colors.filter { $0.name.localizedCaseInsensitiveContains(text) }
    }

    if scope != .all {
      colors = colors.filter { $0.tags.contains(scope.rawValue) }
    }

    if !tokens.isEmpty {
      let tokenStrs = tokens.map { $0.rawValue }

      colors = colors.filter { color in
        let tags = color.tags.filter { $0 != Scope.primary.rawValue && $0 != Scope.secondary.rawValue }
        return tokenStrs.allSatisfy { tags.contains($0) }
      }
    }

    return colors
  }

  var body: some View {
    NavigationStack {
      // The VStack is required here for the navigation title and toolbar
      VStack {
        List {
          Section {
            ForEach(results) { color in
              Text(color.name)
            }
          }
        }
        .searchable(
          text: $text,
          tokens: $tokens,
          prompt: "Search colors"
        ) { token in
          // These appear as labels in the search bar
          switch token {
          case .redish: Text("Redish")
          case .yellowish: Text("Yellowish")
          case .blueish: Text("Blueish")
          }
        }
        .searchScopes($scope) {
          Text("All").tag(Scope.all)
          Text("Primary").tag(Scope.primary)
          Text("Secondary").tag(Scope.secondary)
        }
        .searchSuggestions {
          // This mirrors search results, but this could be a completely different set
          ForEach(results) { color in
            Text(color.name)
              .searchCompletion(color.name)
          }
        }
      }
      .navigationTitle("Colors")
      .toolbar {
        ToolbarItem {
          Menu {
            ForEach(Token.allCases, id: \.rawValue) { token in
              Button {
                // Toggle the selection of a token
                if !tokens.contains(where: { $0 == token }) {
                  tokens.append(token)
                } else {
                  tokens.removeAll { $0 == token }
                }
              } label: {
                // If the token is selected
                if tokens.contains(token) {
                  Label(token.rawValue.capitalized, systemImage: "checkmark.circle")
                } else {
                  Label(token.rawValue.capitalized, systemImage: "circle")
                }
              }
            }
          } label: {
            // If any tokens are selected
            if tokens.isEmpty {
              Image(systemName: "line.3.horizontal.decrease.circle")
            } else {
              Image(systemName: "line.3.horizontal.decrease.circle.fill")
            }
          }
        }
      }
    }
  }
}

struct SearchExample_Previews: PreviewProvider {
  static var previews: some View {
    SearchExample()
  }
}
