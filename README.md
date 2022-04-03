# Note feature for Capstone

The project shows a simple Flutter application that allows users to create new notes, as well as editing their personal account.

## Preview

For a full demo of the application: https://www.loom.com/share/8faa8af3b8eb4dda90387d4d9e4ae45b 

## User Story

- Create a new note (add title/date/content/image)
- Delete a note
- View a note
- Change account's name and avatar

## Important bits

`lib/main.dart` </br>
Here the app sets up objects it needs to track state: a list of notes in the preview mode.

</br>

`lib/noteui/editnote.dart` </br>
This directory contains widgets to create a new note.

</br>

`lib/noteui/note.dart` </br>
This directory contains widgets to display the details of a specific note and the preview of all the notes in the default main screen.

</br>

`lib/accountui/editaccount.dart` </br>
This directory contains widgets to edit the account's name and avatar.


