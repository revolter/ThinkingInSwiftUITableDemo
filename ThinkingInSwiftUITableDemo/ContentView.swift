//
//  ContentView.swift
//  ThinkingInSwiftUITableDemo
//
//  Created by Iulian Onofrei on 05/06/2020.
//  Copyright © 2020 Iulian Onofrei. All rights reserved.
//

import SwiftUI

struct WidthPreference: PreferenceKey {
	static let defaultValue: [Int:CGFloat] = [:]
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value.merge(nextValue(), uniquingKeysWith: max)
	}
}

extension View {
	func widthPreference(column: Int) -> some View {
		background(GeometryReader { proxy in
			Color.clear.preference(key: WidthPreference.self, value: [column: proxy.size.width])
		})
	}
}

struct Table<Cell: View>: View {
	var cells: [[Cell]]
	let padding: CGFloat = 5
	@State private var columnWidths: [Int: CGFloat] = [:]

	func cellFor(row: Int, column: Int) -> some View {
		cells[row][column]
			.widthPreference(column: column)
			.frame(width: columnWidths[column], alignment: .leading)
			.padding(padding)
	}

	var body: some View {
		return VStack(alignment: .leading) {
			ForEach(cells.indices) { row in
				HStack(alignment: .top) {
					ForEach(self.cells[row].indices) { column in
						self.cellFor(row: row, column: column)
					}
				}
				.background(row.isMultiple(of: 2) ? Color(.secondarySystemBackground) : Color(.systemBackground))
			}
		}
		.onPreferenceChange(WidthPreference.self) { self.columnWidths = $0 }
	}
}

struct ContentView: View {
	@Binding var value: Double

	var body: some View {
		Table(cells: [[
			AnyView(Text("Very long text")),
			AnyView(Slider(value: self.$value))
		], [
			AnyView(Text("Short")),
			AnyView(Slider(value: self.$value))
		]])
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(value: .constant(1))
	}
}
