# Landmark_Remark
By: Yulia He 

Technical Challenge from TigerSpike.



## Introduction

This app allows users to save short notes based on location on a map. Every location will be displayed on the map,  and every note will be listed in "Community". They can be viewed by any user. User also can have a look at his own notes list or other users' notes lists in user "Profile". A search function provided for searching the notes with specific content or username.


## For Tester
* Please open the `Landmark Remark.xcworkspace` to run this app.

* You have to go `Debug -> Simulate Location`  to give Simulator a default location manually, as running with Simulator cannot get current location automatically.

* You may login by the account with email `test@gmail.com` and password `Abc12345`. You can also create your own account.


## Outline

### Architecture
Model-View-Controller framework (MVC)

##### Model
* `User.swift` <\br>
* `Note.swift` <\br>
* `Location.swift` <\br>
With a `DataManager.swift` to manager data model. It can help me store the data into the database effectively.

##### View
* `Main.storyboard` - including user login/signup view to authenticating user information and homepage to show the map view. In the homepage, there are three entries to access three functionalities, which are saving a note, profile to browse the user's own notes, and community to check all notes post by all users. <\br>
* `Community.storyboard` - List all notes created by all users. <\br>
* `Profile.storyboard` - List all notes creates by some specific user with his personal information. <\br>
* `LaunchScreen.storyboard` - View when launching the app. <\br>

##### Controller
These controllers are used to `transfer data between database and views`. For instance, all information displayed on the `View` are fetched from database by `Controller`, and all data `model` get from view, such as content typing in the textfield, are stored in the database by `Controller` either.

### Backend
[Firebase](https://firebase.google.com/docs)

Add `GoogleService-Info.plist` configuration file to connect firebase and my project.
To add Firebase SDKs, `CocoaPods` assists me to install and Firebase libraries.

For database, `Firestore` is used here. 
> It is a flexible, scalable NoSQL database for mobile, web, and server development from Firebase and Google Cloud Platform. [more](https://firebase.google.com/docs/firestore)

It's easy to be initialized. After configure the Firebase ```FirebaseApp.configure()``` in the `AppDelegate.swift` and install Firestore using pod ```pod 'Firebase/Firestore'```. You just need to import `FirebaseFirestore` and ```let db = Firestore.firestore()```.


### Data Structure

###### There are three data models(classes), `user`, `note` and `location`. Only the first two are implemented in this test. `Location` will be my future plan to make more extra advanced functions.

Each user has its own username, uid (generated when new account created), and email. There's also a set named personalNotes to store all notes created by this user.

> User
>> username: String </br>
>> uid: String </br>
>> email: String </br>
>> personalNotes: [Note]
>>> noteID: String -> Refer to NoteDocument.documentID

Each note has the content, created date, coordinates. And store userID and username to get who post this note.

> Note
>> content: String </br>
>> date: TimeStamp </br>
>> location: GeoPoint (-> Will refer to Location.location) </br>
>> userID: String  ->  Refer to User.uid </br>
>> username: String -> Refer to User.username </br>

Future Implement: Each location has its coordinates. Then store all users whom mark this location and all notes which are posted on here.

> Location
>> location: GeoPoint </br>
>>> latitude: Double </br>
>>> longitude: Double </br>

>> notes: [Note] </br>
>>> noteID: String -> Refer to NoteDocument.documentID

>> users: [User] </br>
>>> userID: String -> Refer to UserDocument.documentID </br>


### Functionalities & Technology

#### Required functionalities 

- Show current location on a map
    * Set a map view by `Mapkit`. <\br>
    * Get user authorisation first.
        * ```fileprivate func getUserAuthor()``` in `HomeViewController.swift`.
    * Get real-time location by `CoreLocation`.
        * ```func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])``` in `HomeViewController.swift`.
    * All locations are displayed on the map.    
        * Show all locations on the map as long as there is a note created at this location.
            * ```func loadAllNotesData()``` in `HomeViewController.swift`.
        * Click the annotation to look at the details of this note.
        * Real-time update.
            * ```func checkForUpdatesInNote()``` in `HomeViewController.swift`.
    
- Save a short note at the current location
    * Save note data into the database with its content, created date, location, and user information on who post this note.
        * ```@IBAction func createANoteTapped(_ sender: UIButton)``` in `HomeViewController.swift`.
    * After saving a note, an annotation will be set on the map as a mark.
        * ```func addAnnotationsOnMapView()``` in `HomeViewController.swift`.
    
- Profile: Browse the user's information and his notes.
    * `Profile` view allows user to check all his own notes.
        * ```private func fetchNotesOfCurrentUser()``` is used to fetch all notes which are created by the current user.
    * `Profile` also shows the user's username and email. `email` is the unique key for each user. The number of notes belong to the current user are counted here.
    * User also can access another user's profile by selecting the tableview cell in the `Community`.

- Community: See all users' real-time notes.
    * Display all notes from all users as a list ordered according to the created time of each note.
        * ```func loadData()```
    * Real-time update.
        * ```func checkForUpdatesInNote()```
    * User can access other user's profile by selecting the cell.
        * ```func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)```
    
- Search with two scopes at `Community` page.
    * Search by content of note.
    * Search by username.

#### Extra advanced functionalities
- User authentication
    * As a user-based app, signup/login function is necessary.
    * `FirebaseAuth` library gives me support.
    * Password must be at least 8 char with 1 number and 1 BLOCK LETTER.
- Keep login status
    * Use `UserDefault` to store the user logged in. Then every time he opens the app, it would be the homepage unless he signs out from the his own profile page.



## Timeline
Journal of my development.

### This app costs 628 minutes totally (about 10.5 hours).
#### 112 mins study + 475 mins development and test + 41 mins documentation making.

#### 12/08/2020 18:25 Get started from connecting Firebase!

* Build storyboards and connect them. (24 mins)
* Use Auth to implement basic signup/login function. // Firebase Auth (67 mins)
* Do research. Will use Firestore to store user information. // Firestore (20 mins)

21:16 Check out.
##### Duration: 111 mins.

#### 13/08/2020 10:58 Get started from mapkit! Fighting,Yulia!

* Push all files to remote and adjust files structure. (20 mins)
* Create a map view. // MapKit (12 mins)
* Get the current location. // CoreLocation (50 mins)
* Log out. (22 mins)

13:42 Check out.
##### Duration: 104 mins.

#### 14/08/2020 Happy Ekka Holiday!

#### 15/08/2020 08:46 Working with Firestore data model.

* Study Firestore (112 mins)
* Build a data manager as a helper and work with data (186 mins)
* More compulsory functions coming!

21:39 Check out.
##### Duration: 112 mins Studying + 186 mins Developing&Test = 298 mins.

#### 16/08/2020 09:12 Start from searching function.

* Searching. (32 mins)
* All basic functions done! (30 mins)
* Work with documentation. (24 mins)

16:28 Check out
##### Duration: 86 mins

#### 17/08/2020 09:34 Work with documentation and test.

* Documentation (17 mins)
* Real app test (12 mins)
* Submit it! Yeah!

15:00 Check out
##### Duration: 29 mins



## Issues/Limitations

* The text of error label is not regulated. I just returned the error information from the system and printed it on the label. Sometimes it's not readable by users. It could be printed readable if I do some adjustments.
* Loading the map and notes list will spend on ~1s. 
* Only one note shown if there are notes at the same location now. It will be a list as my future plan indicates.
* In `Community`, the search bar will disappear after scrolling the tableview. User have to back to the homepage and re-entry community page to use search function. I got no idea about this.



## Future Development / Improvement

##### Location Class Implement
Then the data model will be more stable and flexible. There will be more interesting and usable. There will be more statistics. User can know how many users have been here and how many notes are saved at here can be count. User can know the number of same locations that both of user himself and another specific user visited.... It would be more fun to make this app be like a social app.
<\br><\br>
And these names of locations will be more precise. i just got ```Placemark.name``` at current version.

##### Indicator
To make this app more usable, I will create some views to show the loading status, or the result of filtering when searching...

##### A note list for each location on the map.
As I mentioned above, there's only one note shown at a location. In the future, I will implement a tableview to show all notes at a specific location. This list is present when user click the annotation

##### Email Verification
Because email is the unique key of a user currently, repeated username is acceptable now. To ensure the security, I will add a email verification to check user. 

##### Hide my notes / Anonymous
Some users would like not to show their notes to other users. It will be an option to ensure privacy. It's easy to be implemented. Just add a Bool attribute into the data model. 

##### More pretty UI
It would be better!

##### More constraints
Such as the content of note can not be empty, etc..
