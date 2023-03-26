//
//  ChartExample.swift
//  SwiftUIExamples
//
//  Created by Stan Lemon on 2/27/23.
//

import SwiftUI
import Charts

struct ChartExample: View {
  var body: some View {
    DateValueLineChart(
      data: build()
    )
    .padding()
  }

  private func build() -> [DateValue] {
    var data = [DateValue]()
    var value = 100.0
    // Start of last month
    var date = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
    for _ in 1...31 {
      value += Double.random(in: -3.99...100.0)
      data.append(
        DateValue(date: date, value: value)
      )

      date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    return data
  }

}

struct ChartExample_Previews: PreviewProvider {
  static var previews: some View {
    ChartExample()
  }
}

struct DateValue: Identifiable, Hashable {
  var id: Date {
    date
  }

  var date: Date
  var value: Double

  var dateAsString: String {
    date.formatted(date: .long, time: .omitted)
  }

  var valueAsString: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    let formatted = formatter.string(from: NSNumber(value: value))!
    return formatted
  }
}

@available(iOS 16.0, macCatalyst 16.0, watchOS 9.0, *)
struct DateValueLineChart: View {
  // Primary color of the chart
  var color = Color.blue
  // Color of the axis and mark when selecting a value on the chart
  var selectedColor = Color.red
  // Stride to use for the x axis
  var stride: Calendar.Component = .day
  // Collection of data for the chart
  var data = [DateValue]()
  // Formatter for the x axis labels
  var xAxisLabel: (_ date: Date, _ stride: Calendar.Component) -> String = { date, stride in
    if stride == .month {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM dd,yyyy"
      return formatter.string(from: date)
    } else {
      let components = Calendar.current.dateComponents([.day], from: date)
      return components.day?.description ?? ""
    }
  }
  // Formatter for the y axis labels
  var yAxisLabel: (_ value: Double) -> String = { value in
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    let formatted = formatter.string(from: NSNumber(value: value))!
    return formatted
  }

  // Track which data has been slected
  @State private var selected: DateValue?

  // Count for use in the stride
  private var count: Int {
    stride == .month ? 7: 3
  }

  var body: some View {
    VStack(spacing: 0) {
      Chart {
        ForEach(data) { result in
          LineMark(
            x: .value("Date", result.date),
            y: .value("Value", result.value)
          )
          .lineStyle(StrokeStyle(lineWidth: 3))
          .foregroundStyle(color)

          AreaMark(
            x: .value("Date", result.date),
            y: .value("Value", result.value)
          )
          .foregroundStyle(
            .linearGradient(
              colors: [
                color.opacity(0.8),
                color.opacity(0.3)
              ],
              startPoint: .top,
              endPoint: .bottom
            )
          )
        }

        if let selected {
          RuleMark(x: .value("Selected date", selected.date))
            .foregroundStyle(selectedColor)

          PointMark(
            x: .value("Selected date", selected.date),
            y: .value("Selected value", selected.value)
          )
          .foregroundStyle(selectedColor)
        }
      }
      .chartXAxis {
        AxisMarks(values: .stride(by: stride, count: count)) { value in
          AxisValueLabel(
            xAxisLabel(value.as(Date.self) ?? Date(), stride)
          )
        }
      }
      .chartYAxis {
        AxisMarks(
          preset: .inset,
          values: .automatic(desiredCount: 5)
        ) { value in
          AxisGridLine()
          AxisTick()
          AxisValueLabel(
            yAxisLabel(value.as(Double.self) ?? 0)
          )
        }
      }
      .chartOverlay { proxy in
        GeometryReader { geometry in
          Rectangle().fill(.clear).contentShape(Rectangle())
            .gesture(DragGesture()
              .onChanged { value in
                updateSelected(at: value.location, proxy: proxy, geometry: geometry)
              }
            )
            .onTapGesture { location in
              updateSelected(at: location, proxy: proxy, geometry: geometry)
            }
        }
      }

      HStack {
        if let selected {
          Text(selected.dateAsString)
          Spacer()
          Text(selected.valueAsString)
        }
      }
      .frame(height: 20)
      .padding(.top, 10)
      .font(.caption)
    }
  }

  private func updateSelected(
    at location: CGPoint,
    proxy: ChartProxy, geometry: GeometryProxy
  ) {
    let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
    guard let date: Date = proxy.value(atX: xPosition) else {
      return
    }

    selected = data
      .sorted(by: {
        abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
      })
      .first
  }
}
