//
//  ProductDetails.swift
//  SwiftUI_HW_2026_09_08
//
//  Created by user301407 on 9/8/26.
//

import SwiftUI

struct ProductDetails: View {
    
    @State var product: Product
    
    var body: some View {
        @Bindable var prodBinding = product
        
        VStack{
            Text("ID: \(prodBinding.id)")
            Text("Name: \(prodBinding.name)")
            Text("Product Number: \(prodBinding.productNumber)")
            Text("Color: \(prodBinding.color)")
            Text("Price: \(String(format: "$%.2f", prodBinding.listPrice))")
            
        }
        .padding()
    }
    
}

#Preview{
    ContentView()
}
