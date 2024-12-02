//
//  EventForm.swift
//  EventsApp
//
//  Created by Ashesh Patel on 2024-12-02.
//
import SwiftUI

struct EventForm: View {
  let mode: Mode
  var event: Event?
  var onSave: (Event) -> Void

  @State private var title: String = ""
  @State private var date: Date = Date()
  @State private var textColor: Color = .black
  @State private var showError = false
  
  var body: some View {
    Form {
      Section {
        TextField("Title", text: $title)
          .foregroundColor(textColor)
        
        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
        
        ColorPicker("Text Color", selection: $textColor)
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Save") {
          if validateForm() {
            switch mode {
            case .add:
              let event = Event(id: UUID(), title: title, date: date, textColor: textColor)
              onSave(event)
            case .edit:
              if var existingEvent = event {
                existingEvent.title = title
                existingEvent.date = date
                existingEvent.textColor = textColor
                onSave(existingEvent)
              }
            case .none:
              return
            }
            
          } else {
            showError = true
          }
        }
        .alert("Validation Error", isPresented: $showError) {
          Button("OK", role: .cancel) {}
        } message: {
          Text("Title cannot be empty.")
        }
        .onAppear {
          if mode == .edit {
            guard let event else { return }
            title = event.title
            date = event.date
            textColor = event.textColor
          }
        }
      }
    }
  }
  
  private func validateForm() -> Bool {
    !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
