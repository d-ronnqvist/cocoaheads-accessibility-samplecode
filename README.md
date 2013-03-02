cocoaheads-accessiblity-samplecode
===================================

# About
This is the presentation and the sample code discussed in my presentation on "Accessiblity for Custom Views” for the March 2013 CocoaHeads Stockholm meet up. 

The code is intendet to show how to give accessible behavior to custom views and view controllers. As an example custom view controller, a swipe gesture based split view was implemented and then made accessible. 

# Try it out
Open the app without VoiceOver and see what it does. It is a gesture based app that deals with colors (that sure sounds very inaccessesible). You can swipe from the side to display a list of color palettes to display in the main view. (Yep, that is all it does).

Now tripple tap to turn on VoiceOver (if you haven’t configured tripple tap to toggle VoiceOver on your device then you really should). A button will appear. 

Try tapping on a few of the colors and have their names being read to you. 

Now tap on the button and see the list slide in from the side. Notice that you can swipe from side to side within the list but not access the “background” by swiping. If you tap on the background then the selection will disappear and double tapping then will slide the list out again. 

Tap on the button again to see the list again. Now use the escape gesture (two finger swipe like a Z) to dismiss the list. This is a system wide “back”/“dismiss” gesture.

# Know defects
The focues on the project is accesisbliy so there are plenty of things missing. One example is that the rotation of the color palette grid is very ugly. Another big thing is localization. The entire app is in English only (sorry). For a non, demo app you should always localize all your accessiblity labels and hints.

# License 
All sample code is put under MIT license to help spread the accessiblity. 

The project includes one method from [this answer by Dave DeLong’s on StackOverflow](http://stackoverflow.com/a/3805354/608157).

The project also lincudes a list of color names from [“Name that Color”](http://chir.ag/projects/ntc/) originally from [Wikipedia](http://en.wikipedia.org/wiki/List_of_colors), [Crayola](http://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors), and [Color-Name Dictionaries](http://people.csail.mit.edu/jaffer/Color/Dictionaries.html). Name that Color is licensed under Creative Commons so that license also applies to the list of color names included in this sample project.
