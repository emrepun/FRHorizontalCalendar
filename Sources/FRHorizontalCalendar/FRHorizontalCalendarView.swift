import SwiftUI

public struct FRHorizontalCalendarView: View {
    
    private enum ViewConstants {
        static let numberOfFittingElements = 7.0
        static let interItemSpacing = 4.0
    }

    @ObservedObject var viewModel: FRHorizontalCalendarViewModel

    public init(viewModel: FRHorizontalCalendarViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 8.0) {
                Text(viewModel.mostProminentMonthText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(uiColor: .systemGray))
                    .padding(.horizontal)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: ViewConstants.interItemSpacing) {
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
            }
        }
    }
    
    private func widthFromScreenWidth(screenWidth: CGFloat) -> CGFloat {
        let width = (screenWidth - (6 * ViewConstants.interItemSpacing) - 1.0) / ViewConstants.numberOfFittingElements
        viewModel.setHeight(width + 28.0)
        return width
    }
}
