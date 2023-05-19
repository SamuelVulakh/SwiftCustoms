//
//  SwiftUIView.swift
//  
//
//  Created by Samuel Vulakh on 5/17/23.
//

import Firebase
import SwiftUI

// All View Extensions
@available(iOS 13.0, *)
extension View {
    
    /// Device Height
    var height: CGFloat { UIScreen.main.bounds.height }
    
    /// Device Width
    var width: CGFloat { UIScreen.main.bounds.width }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Shape Extensions
@available(iOS 13.0, *)
extension Shape {
    /// Enabling Stroke Width Fill On A Shape
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// InsettableShape Extensions
@available(iOS 13.0, *)
extension InsettableShape {
    /// Enabling Stroke Width Fill On A Shape
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// All Color Extensions
@available(iOS 13.0, *)
extension Color {
    
    /// Allowing Initialization From A Hex String
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Firestore Extensions
extension Firestore {
    
    /// Users Database Collection Reference
    static var users: CollectionReference { firestore().collection("users") }
    
    /// Get Current User Document (Is NIL If User Is Not Logged In)
    static var current: DocumentReference? {
        
        /// Making Sure Current User ID Exists
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        // Returning Current User Document If ID Is Valid
        return Firestore.users.document(uid)
    }
}

// Timestamp Extensions
@available(iOS 13.0, *)
extension Binding where Value == Timestamp {
    var dateBind: Binding<Date> { .init { self.wrappedValue.dateValue() } set: { date in self.wrappedValue = Timestamp(date: date) } }
}

@available(iOS 13.0, *)
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
