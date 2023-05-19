//
//  SwiftUIView.swift
//  
//
//  Created by Samuel Vulakh on 5/18/23.
//

import ActivityIndicatorView
import SwiftUI

@available(iOS 14.0, *)
public struct CustomLoading: View {
    
    /// Loading Value
    @Binding var loading: Bool
    
    // Initialization With Error Handle
    public init(_ handle: Binding<Handle>) {
        self._loading = Binding { handle.loading.wrappedValue } set: { v in }
    }
    
    // Initialization Using Bool
    init(_ show: Binding<Bool>) {
        self._loading = show
    }
    
    public var body: some View {
        Group {
            if loading {
                ZStack {
                    
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.7)
                    
                    ActivityIndicatorView(isVisible: .constant(true), type: .gradient([Color(.systemBackground).opacity(0.7), .accentColor], lineWidth: 5))
                        .frame(width: 30, height: 30)
                        .padding(12)
                }
                .zIndex(998)
            }
        }
        .transition(.opacity.animation(.easeInOut))
    }
}

@available(iOS 14.0.0, *)
struct CustomLoading_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoading(.constant(Handle(loading: true)))
    }
}
