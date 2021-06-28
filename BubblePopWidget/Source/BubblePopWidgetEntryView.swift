//
//  BubblePopWidgetEntryView.swift
//  BubblePopWidgetExtension
//
//  Created by Petra Cackov on 26/06/2021.
//

import SwiftUI

struct BubblePopWidgetEntryView : View {
    var entry: BubbleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.bubble.title ?? "")
            Text(entry.bubble.description ?? "")
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(Color(entry.bubble.color.color))
    }
}
