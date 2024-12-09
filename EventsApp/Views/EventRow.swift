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
  
  private var countdown: String {
    let eventDate = self.event.date
    let timeInterval = eventDate.timeIntervalSince(now)
    
    if timeInterval <= 0 {
      return "Event has started!"
    }
    
    let days = Int(timeInterval) / (60 * 60 * 24)
    let hours = (Int(timeInterval) % (60 * 60 * 24)) / (60 * 60)
    let minutes = (Int(timeInterval) % (60 * 60)) / 60
    let seconds = Int(timeInterval) % 60
    
    var components: [String] = []
    if days > 0 {
      components.append("\(days) day\(days > 1 ? "s" : "")")
    }
    if hours > 0 {
      components.append("\(hours) hour\(hours > 1 ? "s" : "")")
    }
    if minutes > 0 {
      components.append("\(minutes) minute\(minutes > 1 ? "s" : "")")
    }
    if seconds > 0 {
      components.append("\(seconds) second\(seconds > 1 ? "s" : "")")
    }
    
    return components.joined(separator: ", ")
  }
  
  
  var body: some View {
    HStack(spacing: 12) {
      // Image with fallback and consistent sizing
      Group {
        if let image = event.image {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .cornerRadius(10)
            .clipped()
        } else {
          Image(systemName: "calendar")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .foregroundColor(.gray.opacity(0.3))
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
      }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(event.title)
          .font(.headline)
          .foregroundColor(event.textColor)
          .lineLimit(2)
          .truncationMode(.tail)
        
        Text(countdown)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundStyle(.secondary)
        .font(.subheadline)
    }
    .frame(minHeight: 60)
    .contentShape(Rectangle()) // Improves tap area
    .padding(.vertical, 5)
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        self.now = Date()
      }
    }
  }
}

#Preview {
  let mockEvent = Event(id: UUID(), title: "Mock Event", date: Date(), textColor: .indigo, image: nil)
  EventRow(event: mockEvent)
}
