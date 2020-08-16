# Landmark_Remark
By: Yulia He 

Technical Challenge from TigerSpike.


# Proposal

## Objective

This app allows users to save short notes based on location on a map. Every note will be displayed on the map and viewed by any user. User also can have a look at other users' notes list in user profile. A search function provided for searching the notes with specific content or username.

## Outline Of My Approach

### Architecture
MVC model

### Backend
Firebase

### Data Structure

Each user has its own username, uid (generated when new account created), and email. </br>
There's also a set named personalNotes to store all notes created by this user.

> User
>> username: String </br>
>> uid: String </br>
>> email: String </br>
>> personalNotes: [Note]
>>> noteID: String -> Refer to NoteDocument.documentID

Each note has the content, created date, coordinates. </br>
And store userID and username to get who post this note.

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
* Show current location on a map
* Save a short note at the current location
* Personal notes list
* See other users' notes
    Show all locations on the map once if there is a note.
    Show the lastest note if there are many notes at the same location.
* Search

#### Extra advanced functionalities
* User authenticate
* Keep login


## Timeline of Development
Journal of my development.

### This app cost 619 minutes totally (about 10 hours).
#### 112 mins study + 477 mins development + 30 mins documentation making.

#### 12/08/2020 18:25 Get started from connecting Firebase!

* Build storyboards and connect them. (24 mins)
* Use Auth to implement basic signup/login function. // Firebase Auth (67 mins)
* Do research. Will use Firestore to store user infomation. // Firestore (20 mins)

21:16 Check out.
##### Duration: 111 mins.


#### 13/08/2020 10:58 Get started from mapkit! Fighting,Yulia!

* Push all files to remote and adjust files structure. (20 mins)
* Create a map view. // MapKit (12 mins)
* Get current location. // CoreLocation (50 mins)
* Log out. (22 mins)

13:42 Check out.
##### Duration: 104 mins.


#### 14/08/2020 Happy Ekka Holiday!

#### 15/08/2020 08:46 Working with Firestore data model.

* Study Firestore (112 mins)
* Build a data manager as a helper and work with data (196 mins)
* More compulsory functions coming!

21:39 Check out.
##### Duration: 112 mins Studying + 196 mins Developing&Test = 308 mins.


#### 16/08/2020 09:12 Start from searching function.

* Searching. (32 mins)
* All basic functions done! (30 mins)
* Work with documentation. (24 mins)

16:28 Check out
##### Duration: 86 mins


#### 17/08/2020 Work with documentation and test.

* Documentation
* Test and fix bugs






## Issues/Limitations

* error label

* loading

* only show the lastest note if there are notes at the same location.

* indicator
loading, filtering...

* tranfer coordinates to name

* UI design

* Security



## Future Development

#### Location Class Implement
