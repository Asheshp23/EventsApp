//
//  EventRow.swift
//  EventsApp
//
//  Created by Ashesh Patel on 2024-12-02.
//
import SwiftUI

struct EventRow: View {
  let event: Event
  @State private var now: Date = Date()
  
  private var relativeDate: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: event.date, relativeTo: now)
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(event.title)
          .font(.headline)
          .foregroundColor(event.textColor)
        Text(relativeDate)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(.secondary)
    }
    .padding(.vertical, 5)
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
        self.now = Date()
      }
    }
  }
}

#Preview {
  let mockEvent = Event(id: UUID(), title: "Mock Event", date: Date(), textColor: .indigo)
  EventRow(event: mockEvent)
}
