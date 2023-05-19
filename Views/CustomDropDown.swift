//
//  SwiftUIView.swift
//  
//
//  Created by Samuel Vulakh on 5/17/23.
//

import SwiftUI

/// Making Different Values Compatible With the Drop Down
public protocol DropDownUsable {
    var stringValue: String { get set }
}

/// Making A String Usable In The Drop Down
extension String: DropDownUsable {
    public var stringValue: String {
        get { self }
        set { self = newValue }
    }
}

/// Making A Bool Usable In The Drop Down
extension Bool: DropDownUsable {
    public var stringValue: String {
        get { description }
        set { self = newValue == "true" }
    }
}

/// Making A CGFloat Usable In The Drop Down
extension CGFloat: DropDownUsable {
    public var stringValue: String {
        get { description }
        set { self = CGFloat(Double(newValue) ?? 0.0) }
    }
}

/// Making A CGFloat Usable In The Drop Down
extension Float: DropDownUsable {
    public var stringValue: String {
        get { description }
        set { self = Float(Double(newValue) ?? 0.0) }
    }
}

/// Making A Integer Usable In The Drop Down
extension Int: DropDownUsable {
    public var stringValue: String {
        get { description }
        set { self = Int(newValue) ?? 0 }
    }
}

@available(iOS 14.0, *)
public struct CustomDropDown: View {
    
    /// Value
    @Binding var value: DropDownUsable
    
    /// All Drop Down Options
    let options: [DropDownUsable]
    
    /// Title of Text Field
    let title: String
    
    /// Show Top Title (By Default It Is Not shown)
    let showTitle: Bool
    
    /// Textfield Text Color
    let textColor: Color
    
    /// Primary Color
    let primary: Color
    
    /// Secondary Color
    let secondary: Color
    
    /// Background Color
    let background: Color
    
    /// Corner Radius
    let cornerRadius: CGFloat
    
    /// Border Width
    let borderWidth: CGFloat
    
    /// The Color Of The Border
    let borderColor: Color
    
    /// If You Would Like To Add Right Content, You Can Do So Here
    let right: AnyView
    
    /// If You Would Like To Add Right Content, You Can Do So Here
    let left: AnyView

    public init(
        _ title: String,
        value: Binding<some DropDownUsable>,
        options: [DropDownUsable],
        showTitle: Bool = false,
        textColor: Color = .primary,
        primary: Color = .primary,
        secondary: Color = .white,
        background: Color = Color(.secondarySystemBackground),
        cornerRadius: CGFloat = 12,
        borderWidth: CGFloat = 1,
        borderColor: Color = .primary,
        right: () -> some View =  { VStack { }.frame(width: 0, height: 0) },
        left: () -> some View = { VStack { }.frame(width: 0, height: 0) }
    ) {
        self._value = Binding {
            value.wrappedValue
        } set: { v in
            value.wrappedValue.stringValue = v.stringValue
        }
        self.title = title
        self.options = options
        self.showTitle = showTitle
        self.textColor = textColor
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.left = AnyView(left())
        // You Can Only Use Right Content If Item Is Not A Password And Textfield Is Not Clearable
        self.right = AnyView(right())
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            
            // Title
            if showTitle {
                Text(title)
                    .foregroundColor(secondary)
                    .font(.system(size: 17))
            }
            
            Menu {
                ForEach(options.filter { $0.stringValue != "Select" }, id: \.stringValue) { option in
                    Button {
                        withAnimation { value = option }
                    } label: {
                        Text(option.stringValue)
                    }
                }
            } label: {
                HStack(spacing: 15) {
                    
                    left
                    
                    Text(value.stringValue.isEmpty || value.stringValue == "Select" ? title : value.stringValue)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 55)
                    right
                }
                .foregroundColor(.primary)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(background, strokeBorder: borderColor, lineWidth: borderWidth)
                )
            }
        }
    }
}

@available(iOS 14.0.0, *)
struct CustomDropDown_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropDown("Test", value: .constant(""), options: [false, true])
    }
}
