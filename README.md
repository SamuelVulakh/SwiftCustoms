# SwiftCustoms

SwiftCustoms is a swift package I have developed that contains all of the utitlies that I have created that I use on a regular basis to create SwiftUI applications. There are textfields, dropdowns, alerts, image pickers, firebase authentication, firestore management, etc.

If you'd like to contribute, feel free to fork the collection and submit a pull request any time.

Hopefully in the near future I will be adding payment boilerplates, among other useful things

## CustomTextField
The CustomTextField that I have built is basically a single text field with parameters that can be added instead of adding your own attributes
```swift

// This Is What The Initializer Looks Like
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
        secondary: Color = .white,
        background: Color = .white,
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
     )
    
    // This Is An Example Of How To Use The TextField 
    VStack {
      ...
      CustomTextField("Text", $text)
      ...
    }
    
    // If The Text Field Is A Password
    VStack {
      ...
      CustomTextField("Text", $text, isPassword: true)
      ...
    }
    
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
