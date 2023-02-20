//
//  FileExporterExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/20/23.
//

import SwiftUI
import UniformTypeIdentifiers

// An example of exporting a file
struct FileExporterExample: View {
  @State private var isExporting = false
  @State private var document: ExportDocument?
  @State private var errorMessage: String?
  @State private var filePath: URL?
  private var exporter: Exporter = ItemExporter()

  var body: some View {
    VStack(alignment: .center) {
      Button("Export Items") {
        document = ExportDocument(data: exporter.export())
        isExporting = true
      }
      .fileExporter(
        isPresented: $isExporting,
        document: document,
        contentType: .plainText,
        defaultFilename: exporter.fileName()
      ) { result in
        switch result {
        case .success(let url):
          filePath = url
          errorMessage = nil
        case .failure(let error):
          filePath = nil
          errorMessage = error.localizedDescription
        }
      }

      if let filePath {
        Text("Saved to \(filePath.absoluteString)")
          .foregroundColor(.green)
          .padding(.vertical)
      }

      if let errorMessage {
        Text("An error has occurred: \(errorMessage)")
          .foregroundColor(.red)
          .padding(.vertical)
      }
    }
  }
}

// Exporter
protocol Exporter {
  func export() -> Data
  func fileName() -> String
}

// Exporter for Item objects
struct ItemExporter: Exporter {
  // Date formatter that does not use colons or slashes
  private let formatter: Formatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [
      .withDashSeparatorInDate,
      .withSpaceBetweenDateAndTime,
      .withFullDate,
      .withTime
    ]
    return formatter
  }()

  func export() -> Data {
    var lines: [String] = []
    // Add headers
    lines.append(createCsvRow(["ID", "Name", "Description", "Tags", "Created"]))
    // Add lines for each item
    lines.append(contentsOf: items.map {
      createCsvRow([
        "\($0.id)",
        $0.name,
        $0.description,
        $0.tags.joined(separator: ", "),
        "\($0.created)",
      ])
    })

    return lines.joined(separator: "\n").data(using: .utf8)!
  }

  private func createCsvRow(_ items: [String]) -> String {
    // Wrap each field in quotes, and escape any quotes in existing values
    return items.map({ column in
      "\"" + column.replacingOccurrences(of: "\"", with: "\\\"") + "\""
    })
    .joined(separator: ",")
  }

  func fileName() -> String {
    "\(formatter.string(for: Date())!)-Items.csv"
  }
}

class ExportDocument: FileDocument {
  static internal var readableContentTypes: [UTType] { [.plainText] }

  private var data: Data

  init(data: Data) {
    self.data = data
  }

  required init(configuration: ReadConfiguration) throws {
    if let data = configuration.file.regularFileContents {
      self.data = data
    } else {
      throw CorruptedFileError()
    }
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    return FileWrapper(regularFileWithContents: data)
  }
}


struct FileExporterExample_Previews: PreviewProvider {
  static var previews: some View {
    FileExporterExample()
  }
}

struct CorruptedFileError: Error {}
