import SwiftUI

public struct FRHorizontalCalendarView: View {
    
    @ObservedObject var viewModel: FRHorizontalCalendarViewModel
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 8.0) {
                Text(viewModel.mostProminentMonthText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(uiColor: .systemGray))
                    .padding(.horizontal)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 2) {
                        ForEach(Array(viewModel.allDays.enumerated()), id: \.element) { index, day in
                            VStack(alignment: .center, spacing: 4.0) {
                                Text(viewModel.dayStringFor(day.date))
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(viewModel.dayStringForegroundColorFor(day))
                                Text(viewModel.dateStringFor(day.date))
                                    .font(.callout)
                                    .foregroundStyle(viewModel.dateStringForegroundColorFor(day))
                            }
                            .padding(4.0)
                            .frame(width: widthFromScreenWidth(screenWidth: proxy.size.width), height: widthFromScreenWidth(screenWidth: proxy.size.width))
                            .background(content: {
                                viewModel.backgroundColorFor(day)
                                    .cornerRadius(widthFromScreenWidth(screenWidth: proxy.size.width) / 2)
                            })
                            .contentShape(Rectangle())
                            .onAppear {
                                viewModel.dayAppeared(day)
                            }
                            .onTapGesture {
                                viewModel.didTapOnDayAt(index)
                            }
                            .onDisappear {
                                viewModel.dayDisappeared(day)
                            }
                        }
                    }
                    .flipsForRightToLeftLayoutDirection(true)
                    .environment(\.layoutDirection, .rightToLeft)
                }
                .flipsForRightToLeftLayoutDirection(true)
                .environment(\.layoutDirection, .rightToLeft)
                .scrollIndicators(.hidden)
                .frame(height: widthFromScreenWidth(screenWidth: proxy.size.width) + 8.0)
            }
        }
    }
    
    private func widthFromScreenWidth(screenWidth: CGFloat) -> CGFloat {
        // 2.75 is not super accurate, but it is the spacing between items in the grid
        // for some reason I couldn't get it to respect spacing provided on initialisation.
        (screenWidth - 32 - (6*2)) / 7
    }
}
