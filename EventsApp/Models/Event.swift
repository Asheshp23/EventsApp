//
//  Event.swift
//  EventsApp
//
//  Created by Ashesh Patel on 2024-12-02.
//
import Foundation
import SwiftUICore

struct Event: Identifiable, Comparable {
  static func < (lhs: Event, rhs: Event) -> Bool {
    lhs.date < rhs.date
  }
  
  let id: UUID
  var title: String
  var date: Date
  var textColor: Color
}

enum Mode {
  case add
  case edit
  case none
}
