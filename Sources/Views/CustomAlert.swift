//
//  SwiftUIView.swift
//  
//
//  Created by Samuel Vulakh on 5/17/23.
//

import SwiftUI

/// Custom Alert View
@available(iOS 13.0, *)
public struct CustomAlert: View {

    /// Error Handle
    var value: Binding<ErrorHandle?>
        
    /// Timer That Is Updated Every Second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /// Time That Alert Is Displayed For
    @State var time: Int = 0
    
    /// Total Time The Alert Will Be Displayed For
    let displayTime: Int
    
    /// Checks If Alert Is For Error Or Notification
    var isErr: Bool {
        switch value.wrappedValue {
        case .err(_):
            return true
        case .notification(_):
            return false
        case .none:
            return false
        }
    }
    
    // Initializing From Error Handle
    public init(_ handle: Binding<Handle>, displayTime: Int = 2) {
        self.value = Binding { handle.wrappedValue.value } set: { v in handle.wrappedValue = Handle(v) }
        self.displayTime = displayTime
    }
    
    // Initialization From Standard Variable
    public init(_ show: Binding<Bool>, error: Binding<Bool>, text: Binding<String>, displayTime: Int = 2) {
        self.value = Binding {
            show.wrappedValue ? error.wrappedValue ? .err(text.wrappedValue) : .notification(text.wrappedValue) : nil
        } set: { _ in
            show.wrappedValue = false
            error.wrappedValue = false
            text.wrappedValue = ""
        }
        self.displayTime = displayTime
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Displaying Alert At Bottom Of Screen
            Spacer()
            
            HStack {
                
                // If Alert Is An Error, Display Exclamation Mark
                if isErr {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 25))
                }
                
                // Displaying Error Description
                Text(value.wrappedValue?.errorDescription ?? "")
            }
            .frame(width: 315, alignment: .leading)
            .padding()
            .font(.system(size: 15))
            .foregroundColor(.white)
            .background(isErr ? Color.red : Color.accentColor)
            .cornerRadius(10)
            .padding(.bottom, value.wrappedValue == nil ? 0 : 30)
            .opacity(value.wrappedValue == nil ? 0 : 1)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: -5, y: -5)
            .animation(.spring(), value: value.wrappedValue)
        }
        .zIndex(999)
        // Descreasing Time Remaining When Timer Value Changes
        .onAppear { time = displayTime }
        .onReceive(timer) { _ in
            if time > 0 {
                time -= 1
            } else {
                time = displayTime
                withAnimation { value.wrappedValue = nil }
            }
        }
    }
}


/// Error Handle
struct Handle {
    
    /// Value Of Error Handle
    var value: ErrorHandle?
    
    /// General Loading
    var loading: Bool
    
    // Initialization
    init(_ value: ErrorHandle? = nil, loading: Bool = false) {
        self.value = value
        self.loading = loading
    }
}

/// Error Handle Value
enum ErrorHandle: Error, Equatable {
    
    /// Error For Display
    case err(_ description: String)
    
    /// Notification For Display
    case notification(_ description: String)
}

/// Localized Description For Error
extension ErrorHandle: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .err(let value):
            return value
        case .notification(let value):
            return value
        }
    }
}


@available(iOS 13.0.0, *)
struct SomeOtherView: View {
    
    /// Determines Whether The Alert Is An Error
    @State var isError = false
    
    /// Shows The Alert
    @State var show = false

    /// The Alert Message
    @State var message = ""
    
    var body: some View {
        ZStack {
            
            Button {
                self.show = true
                self.isError = true
                self.message = "This Is An Error"
            } label: {
                Text("Show Alert")
            }
            
            // The CustomAlert zIndex is set to 999, so it will be layered on top of everything by default
            CustomAlert($show, error: $isError, text: $message)
            // Or, to use a custom displayTime
            CustomAlert($show, error: $isError, text: $message, displayTime: 3)
        }
    }
}

@available(iOS 13.0.0, *)
struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        SomeOtherView()
    }
}
