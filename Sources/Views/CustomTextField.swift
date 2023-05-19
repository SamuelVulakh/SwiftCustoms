//
//  SwiftUIView.swift
//  
//
//  Created by Samuel Vulakh on 5/17/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct CustomTextField: View {
    
    /// Text Value
    @Binding var text: String
    
    /// Title of Text Field
    let title: String
    
    /// Show Top Title (By Default It Is Not shown)
    let showTitle: Bool
    
    /// Password Variables
    let isPassword: Bool
    
    /// If it is a password, this is the boolean for whether to show the actual text or bubbles
    @State var showPasswordText: Bool = false
    
    /// TextField Width (By Default Will Fill Its Frame)
    let width: CGFloat?
    
    /// TextField Height (By Default Will Fill Its Frame)
    let height: CGFloat?
    
    /// Textfield Font
    let font: Font?
    
    /// Textfield Text Color
    let textColor: Color
    
    /// Primary Color
    let primary: Color
    
    /// Secondary Color
    let secondary: Color
    
    /// Background Color
    let background: Color
    
    /// Size Of Vertical Padding Between Textfield And Border
    let innerVerticalPadding: CGFloat?
    
    /// Size Of Horizontal Padding Between Textfield And Border
    let innerHorizontalPadding: CGFloat?
    
    /// Textfield Padding Around View
    let outerPadding: Edge.Set
    
    /// Size Of Padding Around Textfield
    let outerPaddingSize: CGFloat?
    
    /// Corner Radius
    let cornerRadius: CGFloat
    
    /// Border Width
    let borderWidth: CGFloat
    
    /// Display Clear Text Button
    let clearable: Clearable
    
    /// Bool To Show Done Button On Keyboard Navigation Bar
    let done: Bool
    
    /// For Error Handling (Will Turn TextField Color Red)
    @Binding var error: Bool
    
    /// Determines If Textfield Is Disabled
    @Binding var disabled: Bool
    
    /// Focus State For Done Button
    @FocusState var isFocused
    
    /// Get Whether Text Is Clearable
    private var isClearable: Bool {
        switch clearable {
        case .yes(_, _, _):
            return true
        case .no:
            return false
        }
    }
    
    /// If You Would Like To Add Right Content, You Can Do So Here
    let right: AnyView
    
    /// If You Would Like To Add Right Content, You Can Do So Here
    let left: AnyView

    init(
        _ title: String,
        text: Binding<String>,
        showTitle: Bool = false,
        isPassword: Bool = false,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        font: Font? = .system(size: 16, weight: .light),
        textColor: Color = .primary,
        primary: Color = .primary,
        secondary: Color = .primary.opacity(0.6),
        background: Color = Color(.secondarySystemBackground),
        innerVerticalPadding: CGFloat? = nil,
        innerHorizontalPadding: CGFloat? = nil,
        outerPadding: Edge.Set = .all,
        outerPaddingSize: CGFloat? = 0,
        cornerRadius: CGFloat = 12,
        borderWidth: CGFloat = 1,
        clearable: Clearable = .no,
        done: Bool = false,
        error: Binding<Bool> = .constant(false),
        disabled: Binding<Bool> = .constant(false),
        right: () -> some View =  { VStack { }.frame(width: 0, height: 0) },
        left: () -> some View = { VStack { }.frame(width: 0, height: 0) }
    ) {
        self._text = text
        self.title = title
        self.showTitle = showTitle
        self.isPassword = isPassword
        self.width = width
        self.height = height
        self.font = font
        self.textColor = textColor
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.innerVerticalPadding = innerVerticalPadding
        self.innerHorizontalPadding = innerHorizontalPadding
        self.outerPadding = outerPadding
        self.outerPaddingSize = outerPaddingSize
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.clearable = clearable
        self.done = done
        self._error = error
        self._disabled = disabled
        self.left = AnyView(left())
        // You Can Only Use Right Content If Item Is Not A Password And Textfield Is Not Clearable
        self.right = AnyView(right())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Title
            if showTitle {
                Text(title)
                    .foregroundColor(error ? .red : secondary)
                    .font(.system(size: 17))
            }
            
            HStack(spacing: 15) {
                
                // If There Is Left Content, Display it
                if let left {
                    left
                }
                
                // If it is a password then you choose whether it is secure or not
                if isPassword && !showPasswordText {
                    SecureField(title, text: $text)
                        .foregroundColor(textColor)
                        .background(background)
                        .focused($isFocused)
                        .disabled(disabled)
                        .font(font)
                } else {
                    // Otherwise just a standard Textfield
                    TextField(title, text: $text)
                        .autocorrectionDisabled(true)
                        .foregroundColor(textColor)
                        .background(background)
                        .focused($isFocused)
                        .disabled(disabled)
                        .font(font)
                }
                
                // If it is a password this is the eye button to show or hide the password
                if isPassword {
                    Button {
                        // Removing Keyboard
                        isFocused = false
                        
                        withAnimation { showPasswordText.toggle() }
                    } label: {
                        Image(systemName: showPasswordText ? "eye.fill": "eye.slash.fill")
                            .foregroundColor(showPasswordText ? .accentColor : .gray)
                    }
                    // If Button Is Clearable
                } else if isClearable {
                    // Only Display Button If Text Is Not Empty
                    if !text.isEmpty {
                        Button {
                            if clearable.animated {
                                withAnimation {
                                    text = ""
                                    clearable.action()
                                }
                            } else {
                                text = ""
                                clearable.action()
                            }
                        } label: {
                            Image(systemName: clearable.circle ? "xmark.circle.fill" : "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    right
                }
            }
            .padding(.vertical, innerVerticalPadding)
            .padding(.horizontal, innerHorizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(background)
//                    .shadow(color: .black.opacity(0.05), radius: 5)
            )
        }
        .padding(outerPadding, outerPaddingSize)
        .frame(width: width, height: height)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if done {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
        .navigationBarHidden(!done)
        .onDisappear {
            isFocused = false
        }
    }
    
    // Clearable Button Enum
    enum Clearable: Equatable {
        case yes(animated: Bool = false, circle: Bool = true, action: ClearableAction? = nil)
        case no
        
        /// Checks If Clearable Item Is A Circle
        var circle: Bool {
            switch self {
            case .yes(_, let circle, _):
                return circle
            case .no:
                return false
            }
        }
        
        /// Checks If Clearable Item Is Animated
        var animated: Bool {
            switch self {
            case .yes(let animated, _, _):
                return animated
            case .no:
                return false
            }
        }
        
        /// Clearable Button Additional Action
        func action() {
            switch self {
            case .yes(_, _, let action):
                action?.action()
            case .no:
                break
            }
        }
    }
}

// Clearable Action
struct ClearableAction: Equatable {
    
    // Conforming To Equatable
    static func == (lhs: ClearableAction, rhs: ClearableAction) -> Bool {
        return true
    }
    
    /// Additional Optional Action When Clearable Button Is Pressed
    let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
}

@available(iOS 15.0, *)
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField("Test", text: .constant(""))
    }
}
