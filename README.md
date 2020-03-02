# Jumbo JS Operations Excercise
JumboOperation is a simple app that interacts with a web view to execute javascript operations. These operations have an associated progress value which are displayed in the app as progress bars.

## Installation
There are no 3rd party dependencies in this project. Simply download the xcode project and fire the project up.

## Approach
Before touching any code I did some reading on web views. Specifically on how to execute javascript and listening to messages which led me to WKScriptMessageHandler. Without any UI I started playing around with the API's (setting a source script, evaluating js, etc). Once I was able to recieve messages back I began building out the UI and breaking up my logic.

## User Experience
Upon downloading the JS file there is a button that adds a new operation. This operation is represented as a UIProgressView... as it loads the color of the progress is shown in purple. If there's an error running the operation (not returned by the message) we show an alert. If a message returns an error, the progress bar turns red. If a message returns completed, the bar turns green. There is an arbitrary limit of 4 operations imposed.

## Architecture + Considerations
The project follows an architecture similiar to Model-View-Presenter. The view controller conforms to a protocol which is set as a delegate of my logic controller object (ie: the presenter). The logic controller houses business logic and interacts with the web view. The view controller passes along user interaction to the logic controller and the logic controller decides what to do next. This lets us mock out our view in unit tests to ensure functions are getting called when expected. 
I tried following single responsiblity principles as best as possible... although compromises were made in some places. Interfaces are set as the dependencies instead of concrete types to allow for better testability.

A shortcut I took was in using indices as id's for operations. This allowed me to access a stack view's arrange sub view at a particular index instead of generating a random string for operations and then interating over the view hierarchy (or using a potentially expensive operation such as viewWithTag(). A more robust datasource would be an improvement. 

## Unit Tests
I wrote a few unit tests testing the view layer and some of the business logic. I'd like to add tests for the model and configurers next.

## Future improvements 
- More robust error handling. There is some error handling in place... but there's also areas in the code where errors are not handled. One example is I don't check to see if the web view loading failed.
- Remove the limit of 4 operations. Make the UI scrollable to remove this limitation or give an option to clear the operations.
- The UX could use improvements, better styling on the button, not having the button jump to the top when first tapped (this is due to all my UI elements being contained inside a stack view). And better styling on the progress views.
- Having the ID next to it's corresponding progress view.
- There are hard coded colors and values throughout the project. I consolidated most strings into a Constants enum... I'd like to do the same. Colors should be shared across the project from a single source.
- Adding more unit tests.

## Screenshots
