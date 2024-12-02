//
//  EventsView.swift
//  EventsApp
//
//  Created by Ashesh Patel on 2024-12-02.
//
import SwiftUI

struct EventsView: View {
  @State private var events: [Event] = []
  @State private var isPresentingForm = false
  @State private var selectedEvent: Event?
  @State private var mode: Mode = .none
  
  var body: some View {
    List(events, id: \.id) { event in
      EventRow(event: event)
        .contentShape(Rectangle())
        .onTapGesture {
          navigateToEditMode(for: event)
        }
        .swipeActions {
          Button(role: .destructive) {
            deleteEvent(event)
          } label: {
            Label("Delete", systemImage: "trash")
          }
        }
    }
    .navigationTitle("Events")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: navigateToAddMode) {
          Image(systemName: "plus")
        }
      }
    }
    .navigationDestination(isPresented: $isPresentingForm) {
      EventForm(mode: mode, event: selectedEvent, onSave: save)
    }
  }
  
  private func navigateToAddMode() {
    Task { @MainActor in
      selectedEvent = nil
      mode = .add
      isPresentingForm = true
    }
  }
  
  private func navigateToEditMode(for event: Event) {
    Task { @MainActor in
      selectedEvent = event
      mode = .edit
      isPresentingForm = true
    }
  }
  
  private func deleteEvent(_ event: Event) {
    if let index = events.firstIndex(of: event) {
      Task { @MainActor in
        events.remove(at: index)
      }
    }
  }
  
  private func save(_ event: Event) {
    switch mode {
    case .add:
      events.append(event)
    case .edit:
      if let index = events.firstIndex(where: { $0.id == event.id }) {
        Task { @MainActor in
          events[index] = event
        }
      }
    default:
      break
    }
    Task { @MainActor in
      isPresentingForm = false
    }
  }
}
