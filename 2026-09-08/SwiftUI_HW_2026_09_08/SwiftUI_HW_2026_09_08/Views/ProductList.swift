//
//  ProductList.swift
//  SwiftUI_HW_2026_09_08
//
//  Created by user301407 on 9/8/26.
//

import SwiftUI

struct ProductList: View {
    
    @State private var products: [Product] = []
    
    var body: some View {
        NavigationStack{
            List(products) { prod in
                NavigationLink(value: prod){
                    VStack(alignment: .leading){
                        Text(prod.name)
                        Text(prod.color)
                    }
                }
            }
            .navigationBarTitle("Product List")
            .navigationDestination(for: Product.self) {
                selectedItem in
                ProductDetails(product: selectedItem)
            }
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new employee")
            }
        }
        .task {
            loadData()
        }
    }
    
    func loadData() {
        products = [
            Product(id: 1, name: "Product 1", productNumber: "PN123", color: "Red", listPrice: 100.00),
            Product(id: 2, name: "Product 2", productNumber: "PN456", color: "Blue", listPrice: 150.00),
            Product(id: 3, name: "Product 3", productNumber: "PN789", color: "Green", listPrice: 200.00),
            Product(id: 4, name: "Product 4", productNumber: "PN101", color: "Yellow", listPrice: 250.00),
            Product(id: 5, name: "Product 5", productNumber: "PN202", color: "Purple", listPrice: 300.00),
        ]
        
    }
}


#Preview{
    ProductList()
}
