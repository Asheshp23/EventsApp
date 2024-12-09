//
//  EventForm.swift
//  EventsApp
//
//  Created by Ashesh Patel on 2024-12-02.
//
import SwiftUI
import PhotosUI

struct EventForm: View {
  let mode: Mode
  var event: Event?
  var onSave: (Event) -> Void
  
  @State private var title: String = ""
  @State private var date: Date = Date()
  @State private var textColor: Color = .black
  @State private var showError = false
  @State private var image: UIImage?
  @State private var imageSelection: PhotosPickerItem? {
    didSet {
      Task {
        do {
          try await loadTransferable(from: imageSelection)
        } catch {
          print("Image loading error: \(error.localizedDescription)")
          image = nil
        }
      }
    }
  }
  
  var body: some View {
    Form {
      Section(header: Text("Event Details")) {
        TextField("Title", text: $title)
          .foregroundColor(textColor)
        
        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
        
        ColorPicker("Text Color", selection: $textColor)
 
        LabeledContent("Image") {
          PhotosPicker(selection: $imageSelection,
                       matching: .images,
                       photoLibrary: .shared()) {
            if let image {
              Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
              Image(systemName: "photo.badge.plus")
                .foregroundColor(.blue)
                .imageScale(.large)
            }
          }
        }
      }
    }
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    .padding()
    .onChange(of: imageSelection) { _, newValue in
      print("Image selection changed: \(String(describing: newValue))")
      Task {
        do {
          try await loadTransferable(from: newValue)
        } catch {
          print("Image loading error: \(error.localizedDescription)")
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Save") {
          if validateForm() {
            switch mode {
            case .add:
              let event = Event(id: UUID(), title: title, date: date, textColor: textColor, image: image)
              onSave(event)
            case .edit:
              if var existingEvent = event {
                existingEvent.title = title
                existingEvent.date = date
                existingEvent.textColor = textColor
                existingEvent.image = image
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
            if let image = event.image {
              self.image = image
            }
            textColor = event.textColor
          }
        }
      }
    }
  }
  
  private func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
    guard let imageSelection = imageSelection else {
      self.image = nil
      return
    }
    
    do {
      if let data = try await imageSelection.loadTransferable(type: Data.self) {
        if let uiImage = UIImage(data: data) {
          // Ensure UI updates happen on the main thread
          await MainActor.run {
            self.image = uiImage
          }
        }
      }
    } catch {
      print("Detailed image loading error: \(error)")
      throw error
    }
  }
  
  private func validateForm() -> Bool {
    !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
