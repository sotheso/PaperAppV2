//
//  AddPaperView.swift
//  PaperAppV2
//
//  Created by Sothesom on 08/10/1403.
//

import SwiftUI
import PhotosUI

struct AddPaperView: View {
    @StateObject private var viewModel = PaperModelView()
    @Environment(\.dismiss) private var dismiss
    
    // Form fields
    @State private var title = ""
    @State private var subtitle = ""
    @State private var content = ""
    @State private var selectedCategory: PaperMod.PaperCategory = .news
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("اطلاعات اصلی") {
                    TextField("عنوان", text: $title)
                    TextField("زیرعنوان", text: $subtitle)
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
                
                Section("دسته\u{200c}بندی") {
                    Picker("انتخاب دسته\u{200c}بندی", selection: $selectedCategory) {
                        ForEach(PaperMod.PaperCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                }
                
                Section("تصویر کاور") {
                    PhotosPicker("انتخاب تصویر", selection: $photoItem, matching: .images)
                    
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("افزودن روزنامه جدید")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("لغو") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("ذخیره") {
                        savePaper()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .onChange(of: photoItem) { _ in
            Task {
                if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
                photoItem = nil
            }
        }
    }
    
    private func savePaper() {
        let paper = PaperMod(
            title: title,
            subtitle: subtitle,
            content: content,
            category: selectedCategory,
            publishDate: Date(),
            publisherName: "ناشر تست", // Replace with actual user name
            publisherID: "test_publisher", // Replace with actual user ID
            viewCount: 0,
            likeCount: 0
        )
        
        viewModel.addPaper(paper, coverImage: selectedImage)
        dismiss()
    }
}

#Preview {
    AddPaperView()
}

// End of file. No additional code.
