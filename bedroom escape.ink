VAR drawer_open = false
//VAR drawer_has_note = true
VAR note_read = false
VAR window_open = false
VAR window_unlocked = false
LIST inventory = note, key

->Bedroom.wakeUp

===Bedroom

=wakeUp
You awaken in a cold, dimly lit room. ->atMattress

=atMattress
 + [(<i>Where am I?</i>)] {inventory !? key:You're on the floor, atop a barren mattress.<br/><br/>(<i>Gross.</i>)|You're standing next to the overturned mattress.} ->atMattress
 * (rub) [Rub eyes] You rub your eyes, adjusting to the lack of light. ->atMattress
 * (look1) {rub} [Look around] You look around the room. There's a single glass window which lets in the evening moonlight. ->atMattress
 * {inventory ? note && !note_read} [Read note] ->readNote ->atMattress
 * (look2) {look1} [Look around more] You notice a small desk directly across the room.
 Besides the window and desk, there's nothing else. Not even a door.->atMattress
 + {LIST_COUNT(inventory) > 0} [Use...]
    + + {inventory ? note} [Note]
        + + + [with]
            + + + + {note_read} [Mattress] {inventory !? key: Following its unintentionally cryptic instructions, you lift the mattress and lean it against the wall.<br/><br/>There's a key lying on the ground where the mattress was.|You've already moved the mattress and found the key.}
              {inventory ? key: ->atMattress | ->takeKey}
            + + + + {!note_read} [Mattress] (<i>What am I supposed to do with this?</i>) ->atMattress
    + + {inventory ? key} [Key]
        + + + [with]
            + + + + [Mattress] (<i>Not sure what I'm supposed to do with it...</i>) ->atMattress
 + {look1} [Approach the window] You approach the window. ->atWindow
 + {look2} [Approach the desk] You approach the desk. ->atDesk
 + [Go to sleep] ->goToSleep ->atMattress
            

=takeKey
 * [Take key] You bend over and pick up the key.
 ~ inventory += key
 ->atMattress

=atWindow
 + [(<i>Where am I?</i>)] You're standing in front of the window. It's {window_open:open|{examineWindow2 && openWindow1:locked }shut.} ->atWindow
 * {inventory ? note && !note_read} [Read note] ->readNote ->atWindow
 * (examineWindow1) [Examine window] It's a sliding glass window. ->atWindow
 + (examineWindow2) {examineWindow1 && !window_open && !window_unlocked} [Examine more] There's a small hole at the bottom of the window. 
    {inventory ? key:(<i>Maybe the key I have will unlock it?</i>)|(<i>Looks like a key might fit.</i>)} ->atWindow
 + (openWindow2) {examineWindow1 && !openWindow1 && !window_open && !window_unlocked} [Open window] You attempt to open the window. It refuses to budge.
    + + [Try again] You try to open the window, again. Still nothing. 
        (<i>Should I try one more time?</i>)
        + + + (openWindow1) [Try again] You try again, putting a little more effort into it. 
        (<i>{examineWindow2:I guess it's locked.|Nope, this thing isn't moving.}</i>) ->atWindow
        + + + [Give up] You decide to give up. ->atWindow
    + + [Give up] You decide to give up. ->atWindow
 + {!window_open && window_unlocked} [Open window] You open the window. The cool, night breeze flows into the room.
    ~ window_open = true
    ->atWindow
 + {openWindow1 && !examineWindow2 && inventory !? key && !window_open && !window_unlocked} [Open window] (<i>Why would I do that? It clearly won't open.</i>) ->atWindow
 + {openWindow1 && examineWindow2 && !window_open && !window_unlocked} [Open window] {inventory ? key: {examineWindow2:It's locked.|It won't budge} (<i>Maybe I should use the key...</i>)|(<i>No need to try again. {examineWindow2:It's clearly locked|It's won't budget}.</i>)} ->atWindow
 + {window_open} [Close window] You close the window.
    ~ window_open = false
    ->atWindow
 + {LIST_COUNT(inventory) > 0} [Use...]
    + + {inventory ? note} [Note]
        + + + [with]
            + + + + {!window_open} [Window] Nothing happens. ->atWindow
            + + + + {window_open} [Window] You toss the note out of the open window.</br></br>(<i>Hope I didn't need that...</i>)
                ~ inventory -= note
                ->atWindow
            + + + + {examineWindow2} [Keyhole] You fold the note and put it in the keyhole. Nothing happens. </br></br>(<i>What did I expect?</i>) ->atWindow
    + + {inventory ? key} [Key]
        + + + [with]
            + + + + {!window_unlocked} [Window] {examineWindow2:(<i>I think this key might unlock the window...</i>)|{openWindow2:The window won't budge. (<i>I might need to find a place to use this key...</i>)|You scratch the glass with the key. (<i>Heh, take that, window.</i>)}} ->atWindow
            + + + + {window_open} [Window] You toss the key out of the open window.</br></br>(<i>Hope I didn't need that...</i>)
                ~ inventory -= key
                ->atWindow
            + + + + {window_unlocked && !window_open } [Window] You scratch the glass with the key. (<i>Heh, take that, window.</i>) ->atWindow
            + + + + {examineWindow2 && !window_unlocked} [Keyhole] You insert the key into the small hole at the base of the window. *<i>click</i>*
                ~ window_unlocked = true
                ->atWindow
            + + + + {window_unlocked} [Keyhole] You insert the key into the small hole at the base of the window, but decide to leave it unlocked. ->atWindow
 + {window_open} [Exit through window] You consider exiting through the open window. ->openWindow
 + {look2} [Approach the desk] You approach the desk. ->atDesk
 + [Return to the bed] You return to the mattress. ->atMattress


=atDesk
 + [(<i>Where am I?</i>)] You're standing in front of the small desk. {examineDesk1: Its only drawer is {drawer_open:open|shut}.} ->atDesk
 * {inventory ? note && !note_read} [Read note] ->readNote ->atDesk
 * (examineDesk1) [Examine desk] A small wooden desk with a single drawer. Seems like a normal thing to have in a bedroom. ->atDesk
 + (examineDrawer1) {drawer_open} [Examine contents] {inventory ? note: There's nothing left in the drawer.|There's an old, yellowish piece of paper in the drawer. The edges are frayed.} ->atDesk
 + {examineDrawer1 && drawer_open && inventory !? note} [Take paper] You take the old paper.
    ~ inventory += note
    //~drawer_has_note = false
    ->atDesk
 + {drawer_open} [Close drawer] You close the drawer.
    ~ drawer_open = false
    ->atDesk
 + {examineDesk1 && !drawer_open} [Open drawer] You reach out and grab the drawer's handle, slowly pulling it out until it won't slide any more.
    ~drawer_open = true
    ->atDesk
 + {LIST_COUNT(inventory) > 0} [Use...]
    + + {inventory ? note} [Note]
        + + + [with]
            + + + + [Desk] (<i>Why would I leave the note on this desk?</i>) ->atDesk
            + + + + {examineDesk1} [Drawer] {drawer_open:(<i>Why would I put the note back?</i>)|The drawer is closed.} ->atDesk
    + + {inventory ? key} [Key]
        + + + [with]
            + + + + [Desk] (<i>Why would I leave the key on this desk?</i>) ->atDesk
            + + + + {examineDesk1} [Drawer] {drawer_open:(<i>Why would I leave the key in the drawer?</i>)|There's nowhere on the drawer to insert the key.} ->atDesk
 + {look1} [Approach the window] You approach the window. ->atWindow
 + [Return to the bed] You return to the mattress. ->atMattress
 
=readNote
You examine the faint, barely legible words on the note.
<b>U DER MAT ESS</b>
(<i>Seems like a few letters have completely faded away.</i>)
~note_read = true
->->

=openWindow
+ [Stay inside] On second thought, you'd rather stay inside a little longer. ->atWindow
* [Exit through the window]
You carefully raise one leg after the other through the opening, until you are sitting on the windowsill.
    * * [Jump]
    You take a deep breath, and jump. ->END


=goToSleep
Are you sure you want to go to sleep?
 + [Yes] You return to sleep, never again waking up. ->END
 + [No] You decide to stay awake. <i>Probably for the better, anyway.</i> ->->
