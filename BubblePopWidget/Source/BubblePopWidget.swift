//
//  BubblePopWidget.swift
//  BubblePopWidget
//
//  Created by Petra Cackov on 26/06/2021.
//

import WidgetKit
import SwiftUI

@main
struct BubblePopWidget: Widget {
    let kind: String = "BubblePopWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BubbleTimeline()) { entry in
            BubblePopWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct BubblePopWidget_Previews: PreviewProvider {
    static var previews: some View {
        BubblePopWidgetEntryView(entry: BubbleEntry(date: Date(), bubble: Bubble(title: "FakeBubble", description: "FakeDescription")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
