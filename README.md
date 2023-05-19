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
    
    // If You'd Like To Add A Title On Top Of The Text Field
    VStack {
      ...
      CustomTextField("Text", $text, showTitle: true)
      ...
    }
    
```

Standard TextField         |  Password TextField      |  TextField With Title
:-------------------------:|:-------------------------:|:-------------------------:
![](https://firebasestorage.googleapis.com/v0/b/shmulakh.appspot.com/o/CustomTextFIeld-Standard.png?alt=media&token=a2ed6f47-b718-466a-b72a-423edfbfbfb7)  |  ![](https://firebasestorage.googleapis.com/v0/b/shmulakh.appspot.com/o/CustomTextField-Password.png?alt=media&token=69dcbc88-32c4-47b2-b374-11679b70a9cb)  |  ![](https://firebasestorage.googleapis.com/v0/b/shmulakh.appspot.com/o/CustomTextField-ShowTitle.png?alt=media&token=d187ade8-1036-43ff-8bb8-b1fc180c2d99)

If you'd like to make the CustomTextField clearable, simply set the ```clearable``` parameter to ```.yes()```. Here is an example:

```swift
    
    // Clearable Initializer
    .yes(animated: Bool = false, circle: Bool = true, action: ClearableAction? = nil)

    // To add an additional action when the text is cleared
    .yes(animated: false, circle: true, action: ClearableAction {
        your code here
    })
    
```

## CustomAlert
The CustomAlert that I have built can use a Handle Object that takes in a value enum (either ```.notification("Some Text")``` or ```.error("Some Text")```) and a loading variable that is used for the CustomLoading object. You also have the option to use 3 variables for the ```error``` value, the ```text``` value, and the ```show```.

There is also a variable for the number of seconds the alert will be displayed for. This is optional and to change the default value (2 seconds), simply add the ```displayTime``` parameter in the initializer.

```swift

// Using The Handle Object
import SwiftUI

struct SomeView: View {
    
    /// Initialize An Error Handle Object
    @State var handle = Handle()
    
    var body: some View {
        ZStack {
            
            Button {
                // To Show An Alert
                handle = Handle(.err("This Is An Error"), loading: false)
                
                // To Show A Notification
                handle = Handle(.notification("This Is A Notification"), loading: false)
            } label: {
                Text("Show Alert")
            }
            
            // The CustomAlert zIndex is set to 999, so it will be layered on top of everything by default
            CustomAlert($handle)
            // Or, to use a custom displayTime
            CustomAlert($handle, displayTime: 3)
        }
    }
}
```


This is how to use the alert using separate variables
```swift

import SwiftUI

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
                self.message = "Some Error"
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
```

Error Alert                |  Notification Alert
:-------------------------:|:-------------------------:
![](https://firebasestorage.googleapis.com/v0/b/shmulakh.appspot.com/o/CustomAlert-Error.png?alt=media&token=90009235-177f-4edf-bc43-034a1850fea7)   |   ![](https://firebasestorage.googleapis.com/v0/b/shmulakh.appspot.com/o/CustomAlert-Notification.png?alt=media&token=4579abe4-7d42-422f-8677-111d044fd83a)

## Custom ImagePicker



## License

[MIT](https://choosealicense.com/licenses/mit/)
