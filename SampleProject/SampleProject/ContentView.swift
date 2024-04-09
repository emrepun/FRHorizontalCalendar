//
//  ContentView.swift
//  SampleProject
//
//  Created by Emre Havan on 08.04.24.
//

import SwiftUI
import FRHorizontalCalendar

struct ContentView: View {

    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        GeometryReader { proxy in
            List {
                // When calendar is used in a scrollable view, we need to set its height
                // to prevent conflict from calendar's scroll view and the scrollable view
                // used outside.
                // Additionally, we also need to wrap it in some sort of a view, like a VStack
                // to make sure the day selection animations work fine.
                // Couldn't find a solution for this at the moment.
                VStack {
                    FRHorizontalCalendarView(viewModel: viewModel.calendarViewModel)
                                        .frame(height: viewModel.calendarHeight ?? 200.0)
                    Button {
                        viewModel.highlightDaysOnCalendar()
                    } label: {
                        Text("Highlight some days")
                            .foregroundStyle(Color.blue)
                    }
                    .padding()

                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
