//
//  BubbleTimeline.swift
//  BubblePopWidgetExtension
//
//  Created by Petra Cackov on 26/06/2021.
//

import SwiftUI
import WidgetKit

struct BubbleTimeline: TimelineProvider {

    typealias Entry = BubbleEntry

    func placeholder(in context: Context) -> BubbleEntry {
        let previewBubble = Bubble(title: "Fake bubble", description: "some fake bubble")
        return BubbleEntry(date: Date(), bubble: previewBubble)
    }

    func getSnapshot(in context: Context, completion: @escaping (BubbleEntry) -> Void) {
        let previewBubble = Bubble(title: "Fake bubble", description: "some fake bubble")
        let entry = BubbleEntry(date: Date(), bubble: previewBubble)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BubbleEntry>) -> Void) {

        Bubble.fetchAllObjects { (bubbles, error) in

            var bubbleEntries: [BubbleEntry] = []

            if let bubbles = bubbles, bubbles.isEmpty == false {
                bubbleEntries = bubbles.compactMap { $0 as? Bubble }.map { BubbleEntry(date: Date(), bubble: $0) }
            } else {
                let previewBubble = Bubble(title: "No bubbles to display", description: "Go to the app and create some bubbles")
                let entry = BubbleEntry(date: Date(), bubble: previewBubble)
                bubbleEntries = [entry]
            }
            let timeline = Timeline(entries: bubbleEntries, policy: .atEnd)
            completion(timeline)
        }
    }
}

