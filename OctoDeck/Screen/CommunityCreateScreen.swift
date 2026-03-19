//
//  CommunityCreateScreen.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2026/03/19.
//

import SwiftUI

struct CommunityCreateScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CommunityCreateViewModel()
    private let onCreated: () async -> Void

    init(onCreated: @escaping () async -> Void) {
        self.onCreated = onCreated
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $viewModel.name)

                DatePicker("Start", selection: $viewModel.startAt)

                DatePicker("End", selection: $viewModel.endAt)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            await viewModel.onSubmit()
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isSubmitting)
                }
            }
            .navigationTitle("New Community")
            .onChange(of: viewModel.isCompleted) {
                if viewModel.isCompleted {
                    Task {
                        await onCreated()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CommunityCreateScreen(onCreated: {})
}
