# FRHorizontalCalendar
Horizontal Single Row Calendar for SwiftUI. From [Fit Records](https://apps.apple.com/app/fit-records-workout-tracker/id6449899890)

## Requirements:
- iOS 17.0

## Installation

FRHorizontalCalendar is available through [SPM](https://swift.org/package-manager/)

Add it as a new package dependency with https://github.com/emrepun/FRHorizontalCalendar

## ✅ Supported Features
- Set the start date for the calendar
- Setting first day as user's first day of the week automatically
- Automatically highlights today on first load
- Highlighting certain days to indicate content availability
- Get notified when user taps on a day
- Get notified when a day becomes visible

## ❌ Unsupported Potential Features (Anyone is welcome to contribute)
- Ability to change colors or fonts
- Paginated scrolling
- Programmatically scrolling to a day
- Programmatically selecting a day

## Getting Started

FRHorizontalCalendar works with a view model, which must be provided by you. But it is pretty simple.

In your view's observable object, where you are going to use the calendar view, initialise an instance of ```FRHorizontalCalendarViewModel```.

Then in your view's initialiser pass this view model to ```FRHorizontalCalendar```.

If you would like to get notified from certain events such as day selection, and day appear, then set your object as the delegate of ```FRHorizontalCalendarViewModel``` by conforming to ```FRCalendarObserving```. Some of its methods are optional, so make sure to check it out for all methods.

### Setting Content Available On Days

It is possible to highlight some days, where there are some content available. Simply call ```setContentAvailableForDaysWithGivenDates(_ dates: [Date])``` and pass the dates where you want calendar to be highlighted. You don't need to worry about what time exactly is the Date, or the duplicates, the calendar will take care of that.

### Removing Content Available On Days

You might want to remove content availability from a day, where you previously set content available. When user deletes some data for example. In that case, call ```removeContentAvailableForDayWithGivenDate(_ date: Date)```.

## Embedding the calendar in a scrollable view

FRHorizontalCalendar, uses a `ScrollView` within, thus, if you add it to a scrollable view, such as `List`, `ScrollView` and etc, you must set a height for it. Otherwise, the calendar view won't be able to layout itself properly, and also the day selection animation will break. But we got you covered for this case as well.

Implement `didSetInitialHeight(_ height: CGFloat)` in your object that conforms to ```FRCalendarObserving```, and whenever it is triggered, set the height to a published property, where your view containing the calendar can set the calendar's frame accordingly. Also, make sure to wrap the calendar view in a VStack or another view, to fix the day selection animation. See the example below:

```swift
// Your observable object (view model)
final class ExampleViewWithCalendarViewModel: ObservableObject, FRCalendarObserving {

  let calendarViewModel: FRHorizontalCalendarViewModel

  @Published var calendarHeight: CGFloat?

  init() {
        let components = DateComponents(year: 2023, month: 1, day: 1)
        let startDate = Calendar.current.date(from: components)!
        self.calendarViewModel = .init(startDate: startDate)
        calendarViewModel.delegate = self
  }

  func didSetInitialHeight(_ height: CGFloat) {
        calendarHeight = height
  }
}

// Your parent view (that contains calendar)
struct ExampleViewWithCalendarView: View {

  @StateObject var viewModel = ExampleViewWithCalendarViewModel()

  var body: some View {
        List {
            VStack {
                FRHorizontalCalendarView(viewModel: viewModel.calendarViewModel)
                    .frame(height: viewModel.calendarHeight ?? 200.0)                
            }
        }
        .listStyle(.plain)
  }
}
```

See the Sample Project for more details about usage and setup.

## Unit Test Friendliness

At the moment, there is no mock provided for `FRHorizontalCalendarViewModel`. That means, when you initialise it, and keep a reference to it from your view models, and if you write unit tests for that view model. You won't be able to mock it. So you won't be able to verify if your object interacts with the calendar view model as expected. I hope to do the necessary changes and refactoring to make this happen soon. But any contribution is always welcome :)
