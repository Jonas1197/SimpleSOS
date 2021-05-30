//
//  SOSWidget.swift
//  SOSWidget
//
//  Created by Jonas Gamburg on 30/05/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

//MARK: - The looks

struct SOSWidgetEntryView : View {
    var entry: Provider.Entry

    private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!
    
    var body: some View {
        //Text(entry.date, style: .time)
        //foregroundColor(.init(.softRed))
        
        ZStack(alignment: .center, content: {
            Rectangle()
                .foregroundColor(.init(.softRed))
            Circle()
                .foregroundColor(.white)
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Circle()
                .foregroundColor(.init(.softRed))
                .frame(width: 130, height: 130, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                Rectangle()
                    .frame(width: 94, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Press here")
                    .font(.custom(Fonts.bold, size: 18))
                    .foregroundColor(.white)
                    
                Rectangle()
                    .frame(width: 94, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
            }
        }
        
        )
        .widgetURL(SOSWidgetEntryView.deeplinkURL)
    }
}

@main
struct SOSWidget: Widget {
    let kind: String = "SOSWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SOSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct SOSWidget_Previews: PreviewProvider {
    static var previews: some View {
        SOSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
