#  MyTimeLine

An example iOS MVVM app with  RxSwift with Realm.

<img src="https://user-images.githubusercontent.com/1758101/56849109-c5328780-691a-11e9-8870-1bfb06823530.png" width="100">


## Architecture
Use `MVVM` with RxSwift on the app (except on the simplistic `PostViewConroller` screen to avoid overengineering.) 

### Model
- `Post` represents posts in the timeline implemented as a `Realm` object.
<img src="https://user-images.githubusercontent.com/1758101/56849119-d5e2fd80-691a-11e9-917f-3e598bf56e3b.png" width="100">

### ViewModel

These view models use `RxSwift` to update their associated views. The pattern is:
- Their variables are `Observable`s. The view's `UIControl`s can bind to them to update the screen.
- Their callback are `Observable`s. The view can bind to them to receive the view model method's responses. 

#### `TimelineViewModel`
<img src="https://user-images.githubusercontent.com/1758101/56849114-cf548600-691a-11e9-809b-da53a6d67406.png" width="100">
It presents the view model of the first screen, `Timeline`. It keeps a list of `[Post]` that 
are displayed in the view's `UITableView`, and another list of  `[Post]` for the `UISearchController`.


####  `ComposeViewModel`
<img src="https://user-images.githubusercontent.com/1758101/56849125-e4c9b000-691a-11e9-9923-3fe5c4742f0d.png" width="100">
It presents the view model of the `Compose` screen. It keeps a `Post` for the view's input form,
which then will be saved to the `Realm` database once the user tap `Create`.



### View
<img src="https://user-images.githubusercontent.com/1758101/56849122-df6c6580-691a-11e9-9f18-847a464d5544.png" width="100">
For each screen, the views are the SDK's `UIViewController`s
This app has 3 main screens: `TimelineViewController`, `ComposeViewController` and 
`PostViewController`. Each of first 2 screens has their associated `ViewModel`. The last 
screen does not as it doesn't require any reactive functionality.   

The reactive views own their associated view models. (See `createCallback`) The view can call a view model's method
and receive the method's response by binding the view model's events. 

The views also are subscribe to the changes of the view model's changes on the models
 in order to correctly update the screens. (See `bindViewtoViewModel`)

### `TimelineCell`
It implements `UITableViewCell` used by `TimelineViewController`. It uses customed 
`NSLayoutConstraint` to programmatically adjust the layout to display different number of photos.

### Database

This app uses `Realm` for database. It stores 1 model class, `Post`. 

Note that `Post` database doesn't directly store image binary into the `Realm` database. When 
a `Post` object is saved, it first copies images to the user's `documents` directory, then only saves
the file names in the `Post` object. This will scale better the read/write time performance when 
the database grows with more and larger images. 

When the app first launches, it does so with pre-populated data for the ease of demo. See
`SeedData` class. 

## Tests
The `XCTest` is used to test model's logic and operations.
- `TestUtils`  tests the foundation logic and outputs.
- `TestViewmodels` tests the view models themselves and the model CRUD.
When running these unit tests, we switch to use in-memory Realm database config 
so that it does not mess up the app's current database. 


The `XCUITest` is used to test the UI interactions implying correctness of 
the app's navigation and view mode's reactive wiring. Each time UI test is runned, 
the database resets to its _test data_ state. The test automation recorded is 
strictly dependent on the _test data_ created by the `SeedData` class. 
- `MyTimelineUITests` tests each part of the navigation of 
the main 3 screens, search and full image viewer. 




