//
//  ContentView.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI

// Tab view representing the various examples
// This view uses scene storage, which should persist the tab selection even if the OS kills the app in the background
struct ContentView: View {
  enum Example: String, Identifiable, Hashable {
    var id: Self { self }
    case search, table, fileExporter, twoColumnSplitView, threeColumnSplitView, toolbar, chart
  }

  @SceneStorage("tabSelection") private var selectionData: String?
  @State private var selection: Example = .search

  var body: some View {
    TabView(selection: $selection) {
      SearchExample()
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(Example.search)

      TableExample()
        .tabItem {
          Label("Table", systemImage: "tablecells")
        }
        .tag(Example.table)

      FileExporterExample()
        .tabItem {
          Label("File Exporter", systemImage: "square.and.arrow.up")
        }
        .tag(Example.fileExporter)

      TwoColumnNavigationSplitViewExample()
        .tabItem {
          Label("2 Column", systemImage: "rectangle.split.2x1")
        }
        .tag(Example.twoColumnSplitView)

      ThreeColumnNavigationSplitViewExample()
        .tabItem {
          Label("3 Column", systemImage: "rectangle.split.3x1")
        }
        .tag(Example.threeColumnSplitView)

      ToolbarExample()
        .tabItem {
          Label("Toolbar", systemImage: "menubar.rectangle")
        }
        .tag(Example.toolbar)

      ChartExample()
        .tabItem {
          Label("Chart", systemImage: "chart.bar")
        }
        .tag(Example.chart)
    }
    .onChange(of: selection) { selection in
      selectionData = selection.rawValue
    }
    .onAppear {
      selection = Example(rawValue: selectionData ?? Example.search.rawValue) ?? .search
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
