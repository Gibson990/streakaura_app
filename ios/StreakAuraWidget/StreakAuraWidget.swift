//
//  StreakAuraWidget.swift
//  StreakAuraWidget
//
//  iOS Home Screen Widget for StreakAura
//

import WidgetKit
import SwiftUI

struct StreakAuraWidget: Widget {
    let kind: String = "StreakAuraWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakAuraProvider()) { entry in
            StreakAuraWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("StreakAura")
        .description("Track your habit streaks and daily glow")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct StreakAuraProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakAuraEntry {
        StreakAuraEntry(
            date: Date(),
            streakText: "14 days 🔥",
            countdownText: "2h left",
            activeToday: "3/5"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakAuraEntry) -> ()) {
        let entry = StreakAuraEntry(
            date: Date(),
            streakText: "14 days 🔥",
            countdownText: "2h left",
            activeToday: "3/5"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Get data from UserDefaults (shared with main app via App Group)
        let userDefaults = UserDefaults(suiteName: "group.com.example.streakaura_app")
        let streakText = userDefaults?.string(forKey: "streak_text") ?? "Start your glow! ✨"
        let countdownText = userDefaults?.string(forKey: "countdown_text") ?? ""
        let activeToday = userDefaults?.string(forKey: "active_today") ?? "0/0"

        let entry = StreakAuraEntry(
            date: Date(),
            streakText: streakText,
            countdownText: countdownText,
            activeToday: activeToday
        )

        // Update every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct StreakAuraEntry: TimelineEntry {
    let date: Date
    let streakText: String
    let countdownText: String
    let activeToday: String
}

struct StreakAuraWidgetEntryView: View {
    var entry: StreakAuraProvider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.streakText)
                .font(.headline)
                .foregroundColor(Color(red: 0.0, green: 0.82, blue: 1.0)) // #00D1FF
            
            if !entry.countdownText.isEmpty {
                Text(entry.countdownText)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(entry.activeToday)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.37, green: 0.09, blue: 0.92), // #5E17EB
                    Color(red: 0.62, green: 0.31, blue: 0.87)  // #9D4EDD
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview(as: .systemSmall) {
    StreakAuraWidget()
} timeline: {
    StreakAuraEntry(
        date: Date(),
        streakText: "14 days 🔥",
        countdownText: "2h left",
        activeToday: "3/5"
    )
}

