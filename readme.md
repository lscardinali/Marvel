# MARVEL

MARVEL is an iOS app that lets you search for your favorite Marvel Heroes.

## Running the Project

- The project doesn't use any third-party dependency manager or Libraries.
- Requires Swift 5 and XCode 10.2 to run.

---

## Architecture

- Built using MVC
- The layers are normally divided between: `View`, `View Controller`, `Repository` and `ServiceProvider`.
- Data flows using `Codable` models and `ViewModels`.

![architecture](https://github.com/lscardinali/Marvel/blob/master/Docs/architecture.jpeg?raw=true)

### View

- Views are all built programatically, using a `ViewConfigurator` protocol to improve setup.
- When needed, a `View` may adopt a `setState` pattern that allows the view to reconfigure itself as result of a state change.
- When needed, a `View` may declare a `delegate` to relay UI events to the ViewController.
- Data displayed in the view is always represented in a form of a `ViewModel`.
- All of this allows the `View` to be very reusable and non ViewController dependent.

### ViewController

- The function of the ViewController is to relay UI events received from the `View` to the `Repository` and update the `View` state when new data is available from the `Repository`.
- Uses dependency injection to allow customized or mocked `Repositories` to be configured.
- When needed, handles the navigation and the Navigation Controller management.

### Repository

- A plain class responsible for returning the needed `ViewModels` to the `ViewController`, parsing raw `Data` from `Services` to a `Codable` model.
- Dependency injection allows mocking `Repositories` easy.
- Most of the business logic is contained within `Repositories`, making them simple to be isolated tested
- Encapsulates one or more `ServiceProviders`

### Service Providers

- Implements the interfaces available in `Service` protocols.
- It's function is to fetch or process some information and return it in raw `Data`
- They should only know how to fetch the data and return it in a generic way.
- Since `Services` are protocols, they can be easily mocked.
- Examples would be the `MarvelService` protocol that declares the interfaces for each needed request of the Marvel API. `MarvelServiceProvider` implements this protocol by providing the concrete networking implementation, while `MarvelServiceStubProvider` implements this protocol to allow mocking in Unit Testing

---

# Tests

#### Unit Tests (94.5% Coverage)

- Tested almost every `View`, isolated
- Tested all `Repositories`, where most of the Business Logic is located
- Tested most of the ViewControllers
- Tested all Extensions

#### UI Tests (Network Dependent)

- Tested all of the use cases happy paths

---

# Extensions

- `UIImageView+URL`: allows `UIImageView` to load images from the network and cache them for later use
- `String+MD5`: allows a `String` to be easily hashed into MD5, used by the Marvel API for requests
- `Date+TimeStamp`: returns the current milliseconds since 1970, used by the Marvel API for requests
- `Reusable`: Makes `UITableViewCells` easier to manage, without the use String ReuseIdentifiers.
- Its referenced in the file header if code has been extracted from Open-Source snippets.

---

# Protocols

- `ViewConfiguration`: defines some interfaces to make it easier to declare constraints, build the view hierarchy and View Setup
- `EndpointType`: makes it easier to declare endpoints to be used with the `MarvelServiceProvider`

---

# Services

- `MarvelServiceProvider`: Provides the concrete implementation of the Marvel Api Networking.
- `FavoriteServiceProvider`: Provider the concrete implementation of the Favorite Heroes storage.
