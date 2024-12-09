//
//  Event.swift
//  EventsApp
//
//  Created by Ashesh Patel on 2024-12-02.
//
import Foundation
import SwiftUI
import UIKit

struct Event: Identifiable, Comparable {
  static func < (lhs: Event, rhs: Event) -> Bool {
    lhs.date < rhs.date
  }
  
  let id: UUID
  var title: String
  var date: Date
  var textColor: Color
  var image: UIImage?
}

enum Mode {
  case add
  case edit
  case none
}
