//
//  GetDogWidgetLiveActivity.swift
//  GetDogWidget
//
//  Created by Roman Rakhlin on 11/12/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GetDogWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GetDogWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GetDogWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GetDogWidgetAttributes {
    fileprivate static var preview: GetDogWidgetAttributes {
        GetDogWidgetAttributes(name: "World")
    }
}

extension GetDogWidgetAttributes.ContentState {
    fileprivate static var smiley: GetDogWidgetAttributes.ContentState {
        GetDogWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GetDogWidgetAttributes.ContentState {
         GetDogWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GetDogWidgetAttributes.preview) {
   GetDogWidgetLiveActivity()
} contentStates: {
    GetDogWidgetAttributes.ContentState.smiley
    GetDogWidgetAttributes.ContentState.starEyes
}
