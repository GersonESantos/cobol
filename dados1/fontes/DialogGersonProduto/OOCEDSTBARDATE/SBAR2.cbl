      $set mfoo
       program-id. "SBAR2".


       class-control.
           Window is class "window"
           CharacterArray is class "chararry"
           OrderedCollection is class "ordrdcll"
           Association is class "associtn"
           Dictionary is class "dictinry"
           CobolComp5 is class "comp5"
           KeyBrd is class "keyboard"
           MessageBox is class "msgbox"
           EntryCallback is class "entrycll"
           Color is class "color"
           Mouse is class "mouse"
           Font is class "font"
           .

      *   This file provides the initial program section structure
          copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different program versions.
       78 ProgramID                value "SBAR2".


      *   StatusBar specific data items
       01 aStatusBar           usage object reference.

       01 wsIndex              pic s9(9) comp-5.

       01 sectionWidths        usage object reference.
       78 firstSectionMinWidth     value 1200.
       78 followingSectionsWidth   value 654.
       78 windowGrabHandleWidth    value 60.
       01 allSectionsWidth     pic s9(9) comp-5.
       01 wsWidth              pic s9(9) comp-5.

       01 wsTime.
          03 wsHours           pic 99.
          03 wsMinutes         pic 99.
          03 filler            pic 9(4).

       01 wsKeyStates          pic x(4) comp-5.

       01 wsBool               pic x comp-5.
          88 isTrue            value 1.
          88 isFalse           value 0.

       01 wsNumOfParts         pic x(4) comp-5.

       01 wsXCoordinate        pic x(4) comp-5.
       01 wsCurrentRightCoord  pic x(4) comp-5.

       78 menuHintTextSection  value 1.

       01 wsApiFlags.
          03 DW-Style          pic x(4) comp-5.
          03 DW-Ex-Style       pic x(4) comp-5.
       01 wsGenericFlags       pic x(4) comp-5.
       01 wsMask               pic x(4) comp-5.

       01 sectionNumber        pic 99.

      *   This file contains generic window flags
          copy "winflags.cpy".

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

      *   The Callout control block - We need the P2-MF-reserved
      *   value that this gives us
          copy "ds-call.cpy".

       local-storage section.

      *   Although no local-storage is used, this section is needed to
      *   allow EntryCallback based recursive calls to the entry points
      *   of this program.

       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined
       01 anEvent              usage object reference.

      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".

      *   The generic interface to Win95 Control routines - data
      *   exists in the screenset datablock - passed here as linkage
          copy "TCED1201.cpb".

       PROCEDURE DIVISION USING DSC-Control-Block
                                Data-Block
                                .

      *   Convert the Call-Function to Uppercase

          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                          BY VALUE Function-Length

          SET aStatusBar TO Object-Reference

          EVALUATE Call-Function

          WHEN "RESIZE"

               PERFORM Resize-Status-Bar-Sections

          WHEN "UPDATE-SECTION-TEXT"

               PERFORM Set-Section-Text

          WHEN "RETRIEVE-SECTION-TEXT"

               PERFORM Get-Section-Text

          WHEN "REFRESH-OBJECT"

               PERFORM Refresh-Status-Bar

          WHEN "CLEAR-OBJECT"

             PERFORM Clear-Object-Function

          WHEN "ENABLE-OBJECT"

      *        Enable the object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "Enable"

          WHEN "DISABLE-OBJECT"

      *        Disable the object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "Disable"

          WHEN "SET-FOCUS"

      *        setFocus on the object Instance, this uses the
      *        AbstractWindow Class method for this control


              INVOKE Object-Reference "setFocus"

          WHEN "HIDE-OBJECT"

      *        Hide the Object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "hide"

          WHEN "SHOW-OBJECT"

      *        show the object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "show"


          WHEN "SET-MOUSE-SHAPE"

      *        Set the mouse shape of the pointer when
      *        over this object Instance

              PERFORM MouseShape-Function


          WHEN "SET-FONT"

      *        Set the font of the object Instance

              PERFORM Set-Font-Function

          WHEN OTHER

              DISPLAY Invalid-Function, " ", Call-Function
              GO TO Status-Bar-Program-Exit

          END-EVALUATE

          INVOKE aStatusBar "accessSystemEvents".


       Status-Bar-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.

       Entry "C" & ProgramID USING EntryPoint-Data.


      * This is the same code as the CREATE function, but made available
      * via an entry point so that the control may be integrated with
      * the Dialog System runtime. Data here is linkage passed by DSGRUN

      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, the co-ordinates for the creation of the
      * control and the datablock master field associated with this control.

          MOVE EntryPanels-Session-ID TO Queue-ID
          MOVE EntryWindow-Data     TO aHwnd
          PERFORM GetWindow-Instance-Routine

      * Although the co-ordinates for this control have been passed
      * they will not be used on creation of the status bar as the
      * initial size and position of the status bar are determined
      * by the dimensions of it's parent window.

          PERFORM Add-Status-Bar-To-Window

          PERFORM Add-Status-Bar-Sections
          PERFORM Refresh-Status-Bar
          PERFORM Set-Default-Text

      * Update the master field with the object reference for the
      * created status bar

          SET EntryObject-Reference TO aStatusBar

          PERFORM Register-Callbacks
          INVOKE aStatusBar "accessSystemEvents".
          EXIT PROGRAM
        .

       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs.

      *   The Dialog System runtime calls this entry point setting
      *   EntryWindow-Data to 0 and then calls it again with
      *   EntryWindow-Data set to 1. For a status bar only
      *   resize on the first call to stop the resize being done twice.

          IF EntryWindow-Data = 0
              SET aStatusBar TO EntryObject-Reference
              PERFORM Resize-Status-Bar-Sections
          END-IF
          EXIT PROGRAM

        .

       Add-Status-Bar-To-Window section.

      *   Add a status bar to the window instance created from
      *   the handle of the Dialog System window.
      *   An object reference for this status bar is returned
      *   in the datablock for later use.

          INVOKE aWindow "addStatusBar" RETURNING aStatusBar
          .

       Add-Status-Bar-Sections section.

      *   Setup the status bar to display menu hint text in
      *   the first section

          MOVE menuHintTextSection TO wsIndex
          INVOKE aStatusBar "setMenuTextIndexNoBorder" USING wsIndex

      *   Create the control, nothing will be painted until the
      *   class library system event loop is resumed

          INVOKE aStatusBar "create"

      *   Set the initial size and position of status bar sections
      *   based on the window width

          PERFORM Resize-Status-Bar-Sections
          .

       Resize-Status-Bar-Sections section.

      * If aStorageClass has not been created yet, then create
      * it, so that it can be used to create the collection below

          IF aStorageClass = NULL
              MOVE 4 TO i
              INVOKE CobolComp5 "newClass" USING i
                                       RETURNING aStorageClass
          END-IF

      *   Create a collection to hold five section width values

          MOVE 5 TO wsIndex
          INVOKE orderedCollection "ofValues" USING aStorageClass
                                                    wsIndex
                                          RETURNING sectionWidths

      *   Get the object reference of the window that contains
      *   the status bar

          INVOKE aStatusBar "getAncestor" RETURNING aWindow

      *   Get the width of this window

          INVOKE aWindow "getWidth" RETURNING wsWidth

      *   Calculate the total width of all the sections
      *   that we intend to draw added together.

          ADD firstSectionMinWidth TO followingSectionsWidth
                   GIVING allSectionsWidth

      *   If the window containing the status bar is not
      *   maximized and has a size border, then we need
      *   to allow for the width of the status bar
      *   occupied by the window grab handle in the
      *   bottom right hand corner of the window.
      *   This allows the sections preceeding the window grab
      *   handle to be correctly right justified without
      *   being over-written by the window grab handle.
      *   NOTE: Maximized windows and windows without a size border
      *   do not have a window grab handle.

          INVOKE aWindow "isMaximized" RETURNING wsBool
          IF isFalse

      * If the window has a size border, then allow for the
      * width of the window grab handle.

             INVOKE aWindow "getApiFlags" RETURNING wsApiFlags
             INVOKE aWindow "convertToGenericFlags"
                                   USING wsApiFlags
                               RETURNING wsGenericFlags
             MOVE pfl-sizeborder TO wsMask
             CALL "CBL_AND" USING wsGenericFlags
                                  wsMask
                         BY VALUE LENGTH OF wsMask
             IF wsMask NOT = 0
                ADD windowGrabHandleWidth TO allSectionsWidth
             END-IF
          END-IF


      *   Calculate the size of the first section based on the
      *   size of the window.
      *   In this example the first section is used for displaying
      *   menu hint text and has a minimum width.
      *   If the window is wider than the minimum width of the first
      *   section plus the width of all the following sections
      *   then make the first section large enough to right
      *   justify the following sections.

          MOVE 1 TO wsIndex
          IF wsWidth > allSectionsWidth
             SUBTRACT firstSectionMinWidth FROM allSectionsWidth

      *      allSectionsWidth is now the width of the following
      *      sections plus the width of the size handle (if
      *      added on in code above).

             SUBTRACT allSectionsWidth     FROM wsWidth
          ELSE
             MOVE firstSectionMinWidth TO wsWidth
          END-IF
          INVOKE sectionWidths "addLast" USING wsWidth

      *   Insert key state section

          MOVE 135 TO wsWidth
          INVOKE sectionWidths "addLast" USING wsWidth

      *   Caps key state section

          MOVE 173 TO wsWidth
          INVOKE sectionWidths "addLast" USING wsWidth

      *   Num lock key state section

          MOVE 164 TO wsWidth
          INVOKE sectionWidths "addLast" USING wsWidth

      *   Section for displaying the current system time

          MOVE 174 TO wsWidth
          INVOKE sectionWidths "addLast" USING wsWidth

      *   Setup the section widths by passing the "setParts"
      *   method of aStatusBar a collection of section widths

          INVOKE aStatusBar "setParts" USING sectionWidths

      *   Destroy the collection, as a new collection is created
      *   for each resize

          INVOKE sectionWidths "finalize" RETURNING sectionWidths
          .

       Set-Section-Text section.

      *   Sets the text of section Numeric-Value to be
      *   text contained in Section-Text

          MOVE IO-Text-Buffer TO Term-Field
          PERFORM Null-Terminate-Routine
          INVOKE characterArray "withValue" USING Term-Field
                                        RETURNING aCharArray

          MOVE Numeric-Value TO wsIndex
          PERFORM Set-wsIndex-Section-Text

          INVOKE aCharArray "finalize" RETURNING aCharArray
          .

       Set-Default-Text section.

      *   Set default text for menu hint text section

          SET aCharArray TO NULL
          MOVE menuHintTextSection TO wsIndex

      *   Make the menu hint text section of the status bar
      *   have no border

          INVOKE aStatusBar "setSectionTextNoBorder"
                                       USING wsIndex
                                             aCharArray
          .

       Get-Section-Text section.

          MOVE Numeric-Value TO wsIndex
          INVOKE aStatusbar "getSectionText" USING wsIndex
                                               RETURNING aCharArray
          MOVE LENGTH OF IO-Text-Buffer TO wsSize
          MOVE SPACES TO IO-Text-Buffer
          INVOKE aCharArray "getValueWithSize" USING wsSize
                                  RETURNING IO-Text-Buffer
          INVOKE aCharArray "finalize" RETURNING aCharArray
          .

       Refresh-Status-Bar section.
          PERFORM Refresh-Time
          PERFORM Refresh-Key-States
          .

       Refresh-Time section.

      *   Get current time

          ACCEPT wsTime FROM TIME
          MOVE SPACES TO Term-Field
          STRING wsHours DELIMITED BY SIZE
                 ":" DELIMITED BY SIZE
                 wsMinutes DELIMITED BY SIZE
            INTO Term-Field

          PERFORM Null-Terminate-Routine

          INVOKE characterArray "withValue" USING Term-Field
                                        RETURNING aCharArray

      *   Section 5 is used in this example to display the current time

          MOVE 5 TO wsIndex
          INVOKE aStatusBar "setSectionText" USING wsIndex
                                                   aCharArray
          INVOKE aCharArray "finalize" RETURNING aCharArray
          .

       Refresh-Key-States section.

      *   Check the status of the Insert key

          INVOKE keyBrd "InsLocked" RETURNING wsBool
          IF isTrue
             INVOKE characterArray "withValue" USING z"INS"
                                           RETURNING aCharArray
          ELSE
             INVOKE characterArray "withValue" USING z"   "
                                           RETURNING aCharArray
          END-IF
          MOVE 2 TO wsIndex
          INVOKE aStatusBar "setSectionText" USING wsIndex
                                                   aCharArray
          INVOKE aCharArray "finalize" RETURNING aCharArray

      *   Check the status of the Caps lock key

          INVOKE keyBrd "CapsLocked" RETURNING wsBool
          IF isTrue
             INVOKE characterArray "withValue" USING z"CAPS"
                                           RETURNING aCharArray
          ELSE
             INVOKE characterArray "withValue" USING z"    "
                                           RETURNING aCharArray
          END-IF
          ADD 1 TO wsIndex
          INVOKE aStatusBar "setSectionText" USING wsIndex
                                                   aCharArray
          INVOKE aCharArray "finalize" RETURNING aCharArray

      *   Check the status of the Num lock key

          INVOKE keyBrd "NumLocked" RETURNING wsBool
          IF isTrue
             INVOKE characterArray "withValue" USING z"NUM"
                                           RETURNING aCharArray
          ELSE
             INVOKE characterArray "withValue" USING z"   "
                                           RETURNING aCharArray
          END-IF
          ADD 1 TO wsIndex
          INVOKE aStatusBar "setSectionText" USING wsIndex
                                                   aCharArray
          INVOKE aCharArray "finalize" RETURNING aCharArray
          .

       Set-wsIndex-Section-Text section.

      *    All sections apart from the menuHintTextSection are
      *    drawn with a border.

           IF wsIndex = menuHintTextSection
               INVOKE aStatusbar "setSectionTextNoBorder"
                                       USING wsIndex
                                             aCharArray
           ELSE
               INVOKE aStatusbar "setSectionText"
                                       USING wsIndex
                                             aCharArray
           END-IF
           .


       Clear-Object-Function section.

      *    Get the number of sections in the status bar

           INVOKE aStatusbar "howManyParts"
                               RETURNING wsNumOfParts
           IF wsNumOfParts > 0
               SET aCharArray TO NULL

      *        Clear all sections apart from sections
      *        2 through 5, as these sections should allways
      *        show the current key states and time.

               PERFORM VARYING wsIndex FROM 1 BY 1
                                   UNTIL wsIndex > wsNumOfParts
                   IF wsIndex < 2
                      OR wsIndex > 5
                       PERFORM Set-wsIndex-Section-Text
                   END-IF
               END-PERFORM
           END-IF
           .

       MouseShape-Function section.

      *        Note that this section provides very simple example of
      *        setting mouse shapes using named system shape values...
      *        You may also set your own pointer shapes using the
      *        fromResource method of the mouseCursor class

      *        1stBuffer is the mouse shape indicator.
      *        Set up a CharacterArray with the name of the pointer
      *        required. Invoke the Mouse setshape method with the
      *        control and pointer required.

      *        Recall this routine to set it normal for this control
               MOVE IO-Text-Buffer TO Term-Field
               PERFORM Null-Terminate-Routine
               INVOKE CharacterArray "withValue" USING Term-Field
                                             RETURNING aCursor

               INVOKE Mouse "setShape" USING Object-Reference
                                             aCursor

      *        This mouse object reference wont be used again so destroy

               INVOKE aCursor "finalize" RETURNING aCursor
               .

       Set-Font-Function section.

      *    This section provides a very simple example of setting
      *    the font of an object.

      *    Note that it is the responsibility of the application
      *    to finalize any new fonts created. These fonts should
      *    be finalized when the objects that reference them
      *    are finalized and when setting new fonts on objects.

      *    Create a character array to hold the facename
      *    specified in IO-Text-Buffer.

           MOVE LENGTH OF IO-Text-Buffer TO i
           INVOKE CharacterArray "fromBuffer" USING i
                                                    IO-Text-Buffer
                                         RETURNING aCharArray

      *    Create a new font using the specified facename, point size
      *    and style.

           INVOKE font "new" USING aCharArray     *> Facename
                                   Numeric-Value  *> Point size
                                   Numeric-Value2 *> Font style
                         RETURNING aFont

           INVOKE aCharArray "finalize" RETURNING aCharArray

      *    Apply the font to the object identified by Object-Reference

           INVOKE Object-Reference "setFont" USING aFont

      *    Return the font in Object-Reference.

           SET Object-Reference TO aFont
           SET aFont TO NULL
           .


       Left-Mouse-Button-Down section.
       Entry ProgramID & "Button1Down" USING anEvent.

      *    Find out which status bar the event occured on

           INVOKE anEvent "getObject" RETURNING aStatusBar

      *    Get the X coordinate where the mouse was clicked

           INVOKE anEvent "getX" RETURNING wsXCoordinate

      *    Find out which section of the status bar was clicked on

      *    To do this we need to get the widths of each status
      *    bar section

           INVOKE aStatusBar "howManyParts" RETURNING wsNumOfParts

           INVOKE aStatusBar "getParts" USING wsNumOfParts
                                    RETURNING sectionWidths

           MOVE 0 TO wsCurrentRightCoord

      *    Check each section to see if the mouse X coordinate is less
      *    than its right coordinate
      *    This allows us to find out which section the mouse was
      *    clicked on

           PERFORM VARYING i FROM 1 BY 1
                     UNTIL i > wsNumOfParts
               INVOKE sectionWidths "at" USING i
                                     RETURNING wsWidth
               ADD wsWidth TO wsCurrentRightCoord
               IF wsXCoordinate <= wsCurrentRightCoord
                   EXIT PERFORM
               END-IF

           END-PERFORM
           MOVE i TO sectionNumber

           INVOKE sectionWidths "finalize" RETURNING sectionWidths

      *    Determine the window handle that will be used to post the
      *    panels2 events to. GetAncestor returns an object ref for the
      *    window, & we can then get its handle using GetID.

           INVOKE aStatusBar "getAncestor" RETURNING aWindow
           INVOKE aWindow "GetID" RETURNING aHwnd

           PERFORM GetDataBlockPointer

      *    Here aStatusbar is set to the object that the
      *    button 1 down mouse event occured on.

           MOVE sectionNumber TO Numeric-Value

      *    Now setup the text for the message box that will be
      *    displayed by the DS screenset

           MOVE SPACES TO IO-Text-Buffer
           STRING "Click on section: "
                                 delimited by size
                   sectionNumber delimited by size
               INTO IO-Text-Buffer

      *----34590 is a user defined event number that the DS screenset
      *    responds to - see DS/PanelsV2 documentation for further
      *    details

           MOVE 34590  TO Event-Type
           PERFORM Post-User-Event-Routine

           EXIT PROGRAM.

       Register-Callbacks section.

           MOVE '"' & ProgramID & z'Button1Down"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-Button1Down TO i
           INVOKE aStatusBar "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback


      *    Always register a callback to delete the dictionary item
      *    when the containing window is deleted.
           MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
           INVOKE EntryCallBack "new" USING MessageName
                                  RETURNING aCallback
           MOVE P2Ce-Destroyed TO i
           INVOKE aStatusBar "SetEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

           PERFORM SaveDataBlockPointer

           .

       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandle" USING aHwnd
                                     RETURNING aWindow
          .

       Resize-Routine Section.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   code is called by DSGRUN when a Window resized event occurs...
      *   the runtime calculates the correct new co-ordinates
      *   following the resize

      *   The EntryWindow-Data flag is used in this context, as a value to
      *   indicate whether to get or set the rectangle details.
      *   0 = Get/ 1 = Set

          IF EntryWindow-Data = 0

      *      The Dialog System Runtime needs to know the current
      *      coordinates of the object instance so it can apply an
      *      adjustment factor to the values that need to change.
             INVOKE EntryObject-Reference "getRectangle"
                                  USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height

          ELSE

      *      Invoke the setRectangle method of the object instance to
      *      reset the physical sizes following a window-sized event
             INVOKE EntryObject-Reference "setRectangle"
                                  USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height
             INVOKE EntryObject-Reference "invalidate"
          END-IF
         .


       Post-User-Event-Routine section.

      * The EntryCallback class has an extended method to enable
      * the posting of a user event to the panels2 module. The Dialog System
      * USER-EVENT dialog table may then act on this event

            INVOKE EntryCallback "PostP2Event" USING Queue-ID
                                                     aHwnd
                                                     Event-Type
            .


       Null-Terminate-Routine Section.

      *   This section loops back from the end of the field until it
      *   encounters a non space - & puts a null in the right place
      *---The buffer sizes used may require user defined values

          MOVE LENGTH OF Term-Field TO j
          PERFORM VARYING i FROM j BY -1 UNTIL i = 0
               IF Term-Field(i:1) NOT = Spaces
                AND NOT = X"00"
                  ADD 1      TO i
                  MOVE x"00" TO Term-Field(i:1)
                  EXIT SECTION
               END-IF
          END-PERFORM
          MOVE x"00" TO Term-Field(j:1).


       SaveDataBlockPointer Section.

      *    Save a pointer to the datablock in a dictionary. This is
      *    so we can get at the correct datablock in the callback code.

      *    I.E. The datablock thats associated with the window on
      *    which an event occurs.

           IF 1stTimeThru

      *       First establish a class for creation of our Association
      *       template. Now PIC X(4) Comp-5 is a class instance
              MOVE 4 TO i
              INVOKE CobolComp5 "newClass" USING i
                                         RETURNING aStorageClass
      *       Now Create an association template using an object
      *       reference and a Pic X(4) Comp-5 data item.
              SET anObject TO NULL
              INVOKE Association "newClass" USING anObject aStorageClass
                                        RETURNING anAssocTemplate

      *       Now create our dictionary (upto 32 items) of associations
              MOVE 32 TO i
              INVOKE Dictionary "ofAssociations" USING anAssocTemplate
                                                       i
                                             RETURNING aDictionary
              SET Not1stTimeThru TO TRUE
            END-IF

      *    Insert the Window/datablock Pointer association into the
      *    dictionary

           SET DataBlock-Pointer TO EntryDatablock-pointer
           INVOKE aDictionary "atPut" USING aWindow DataBlock-Pointer
           .


       GetDataBlockPointer section.

      *     This re-sets this entry point program Datablock variable
      *     to the memory location where we know it exists - the
      *     original location identified by the pointer, retrieved from
      *     our dictionary
            INVOKE aDictionary "at" USING aWindow
                                RETURNING DataBlock-Pointer

            SET ADDRESS OF Data-Block TO DataBlock-Pointer
            .


       The-Object-is-Destroyed section.
       Entry ProgramID & "OnDestroyed" USING anEvent.

          INVOKE anEvent "getObject" RETURNING aStatusBar
          INVOKE aStatusBar "getAncestor" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL
          EXIT PROGRAM
          .


