//
//  HomeView.swift
//  PaperApp
//
//  Created by Sothesom on 24/09/1403.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
        BanereAval()
            .background(Color.gray.opacity(0.2))
            .navigationTitle("PaperApp")
            
        CardView()
        Spacer()
        }
    }
}

#Preview {
    HomeView()
}
//
//// Your imports remain the same
//import SwiftUI
//
//struct HomeView: View {
//    // Add PaperModelView
//    @StateObject private var viewModel = PaperModelView()
//    
//    // Add test data with correct argument order
//    private var testPaper: PaperMod {
//        PaperMod(
//            title: "روزنامه تست",
//            subtitle: "این یک روزنامه تستی است",
//            content: "محتوای تستی برای روزنامه",
//            category: .news,
//            publishDate: Date(),
//            publisherName: "ناشر تست",
//            publisherID: "test_publisher",
//            viewCount: 0,
//            likeCount: 0
//        )
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // Your existing BanereAval remains the same
//                BanereAval()
//                    .background(Color.gray.opacity(0.2))
//                    .frame(height: 200)
//                
//                // Add test controls
//                VStack(spacing: 20) {
//                    Button("اضافه کردن روزنامه تست") {
//                        viewModel.addPaper(testPaper)
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    
//                    Button("دریافت روزنامه‌ها") {
//                        viewModel.fetchPapers()
//                    }
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                
//                // Show loading state
//                if viewModel.isLoading {
//                    ProgressView()
//                }
//                
//                // Show error if exists
//                if !viewModel.errorMessage.isEmpty {
//                    Text(viewModel.errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
//                
//                // Show papers
//                ScrollView {
//                    ForEach(viewModel.papers) { paper in
//                        VStack(alignment: .leading) {
//                            Text(paper.title)
//                                .font(.headline)
//                            Text(paper.category.rawValue)
//                                .font(.subheadline)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                    }
//                }
//                
//                Spacer()
//            }
//            .navigationTitle("PaperApp")
//        }
//    }
//}
//
//#Preview {
//    HomeView()
//}
//
//// End of file. No additional code.
