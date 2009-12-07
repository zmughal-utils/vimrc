" +-----------------------------------------------------------------------------+
" | CHANGING COLOUR SCRIPT                                                      |
" +-----------------------------------------------------------------------------+
" | START                                                                       |
" +-----------------------------------------------------------------------------+
" | REVISONS:                                                                   |
" | FRI 4th DEC 2009:    10.5                                                   |
" |                      Identifier vis 'fix' still too agreessive, tweaked.    |
" |                      10.4                                                   |
" |                      Made the Identifier 'fix' visibility less agressive.   |
" | WED 18TH OCT 2009:   10.3                                                   |
" |                      Trouble-shoot some visibilty problems associated with  |
" |                      syntax elements Pmenu and CursorLine.                  |
" |                      10.2                                                   |
" |                      Further tuning-up.                                     |
" | TUE 17TH OCT 2009:   10.1                                                   |
" |                      Just a quick update. Had to tune-up the white-peak as  |
" |                      it was staying on a bit too long.                      |
" |                      10.0                                                   |
" |                      On the 10.0 version, perhaps the best version. Normal  |
" |                      now blends more smoothly than ever at darker           |
" |                      background ranges, and the background colour at the    |
" |                      lighter ranges now peaks up to a pure white before     |
" |                      coming down again to a tint which can be a shade of    |
" |                      either light-green, cyan, rose. The contrast is great, |
" |                      the visibility is great, and the smoothness is great.  |
" |                      If you haven't tried this before you'll really be      |
" |                      amazed.                                                |
" | SUN 15TH OCT 2009:   9.9                                                    |
" |                      Whilst perhaps not George-Lucas effects, this Normal   |
" |                      elements approaches smoothness as it flips back-and-   |
" |                      forth between dark-based and light-based background    |
" |                      scheme, and remains pretty visible through this        |
" |                      change. This version just sharpens up the contrast     |
" |                      at the dark end of the Normal effect a tad, so it      |
" |                      keeps looking lively.                                  |
" |                      9.8                                                    |
" |                      Made funky adjustments to ease the visual flow of      |
" |                      Normal from dark-light background and vice versa by    |
" |                      individually switching the RGB components up/down one  |
" |                      at a time, e.g. first Red, and so on, as otherwise it's|
" |                      abrupt and causes dis-orientation. Also played with    |
" |                      Statement and improved the visibility as at some of    |
" |                      the dark-background settings it was looking a bit like |
" |                      a carrot-ey orange on top of mud - not very clear.     |
" | MON 9TH OCT 2009:    9.7                                                    |
" |                      Made Comments a bit more usable, although there is a   |
" |                      glitch in the math i can't figure out. This makes the  |
" |                      comments hard to see for a couple of minutes but they  |
" |                      are just about usable. Will keep trying to get to the  |
" |                      bottom of it.                                          |
" | SUN 8TH OCT 2009:    9.6                                                    |
" |                      Made slight tune-up of Comment to make it less strong  |
" |                      Possibily a bit too weak in certain areas but it's     |
" |                      better comment is a little harder to see temporarily   |
" |                      than being too strong. Might work on this later to     |
" |                      get to the bottom of it.                               |
" |                      9.5                                                    |
" |                      Made some fine adjustments around the boundary cases   |
" |                      of Normal and Statement. Now sharper than before.      |
" | SAT 7TH OCT 2009:    9.4                                                    |
" |                      Made the Normal simple. It's light when it's dark,     |
" |                      and darkens as it lightens. Simple. Plus it now blends |
" |                      blends nicely with the other elements particularly     |
" |                      Constant which is very important in the vim system.    |
" |                      9.3                                                    |
" |                      Realised that i had left a slightly exposed area       |
" |                      around the light area of the background. This is where |
" |                      background is light-ish but the Normal text is not     |
" |                      near the dark-light exchange yet. fixed this by        |
" |                      stretching the 'ease' area, or the 'ramping' zone of   |
" |                      the normal text. This ramping zone now covers this     |
" |                      previously exposed zone around the lighter background. |
" |                      9.2                                                    |
" |                      Fine-tuned the dark-boosting around the light-end of   |
" |                      the dark-light background boundary of the Normal       |
" |                      element. When text goes light it's nice and strong,    |
" |                      and similarly now when it goes to dark it's nice and   |
" |                      strong too.                                            |
" |                    o 9.1                                                    |
" |                      Added a new 'dark dip' adjustable ramp to the          |
" |                      'Normal' syntax element, this allows a subtle          |
" |                      incremental 'darkening' of the text as it nears the    |
" |                      point where it will go into 'light' mode. This         |
" |                      darkening helps keep the visibility up right up until  |
" |                      the last minute. Maybe some fine-tuning needed but it's|
" |                      much better as it is than before. Before visibility    |
" |                      just worsened around the point where Normal would      |
" |                      switch from light text to dark text and vice-versa as  |
" |                      the background darkened or lightened. This is no longer|
" |                      true.                                                  |
" |                      9.0                                                    |
" |                      Took out all unecessary debug stuff out of RGB         |
" |                      functions. Now it runs much quicker.                   |
" | MON 2ND OCT 2009:  o 8.9                                                    |
" |                      Removed set whichwrap=h,l command as this was there    |
" |                      only so that the old (cursor movement based) timer     |
" |                      could work. According to the help you shouldn't even   |
" |                      set these keys in whichwrap. It's out now anyway.      |
" |                    o 8.8                                                    |
" |                      Got rid of the time display in the Yukihiro Nakadaira  |
" |                      timer function, and moved a variable definition        |
" |                      outside the routine to make it more efficient.         |
" |                    o 8.7                                                    |
" |                      Fixed problem of 'stolen keypresses' that happened when|
" |                      the user happened to move the cursor at the same time  |
" |                      as the timer routine was happening. Also there were    |
" |                      ocassional glitches with the cursor moving where it    |
" |                      shouldn't. Now this doesn't happen. The new routine    |
" |                      uses a much simpler method. Courtesey of Yukihiro      |
" |                      Nakadaira. (source:                                    |
" |                      http://old.nabble.com/timer-revisited-td8816391.html). |
" | SAT 31ST OCT 2009: o 8.6                                                    |
" |                      Simplified the logic to just 'did i move to cause a    |
" |                      timer previously, and if so where, hence move the      |
" |                      opposite way'. Now it's pretty flawless apart from     |
" |                      when you're on the final line and this line has no     |
" |                      characters and the size of the file is only 3 lines    |
" |                      long. This not only causes a flash/beep and the timer  |
" |                      not to work (hence no automatic colour changes) but    |
" |                      also when you try moving off this line it could go     |
" |                      funny (the cursor mysteriously jumps up a line) but    |
" |                      it's nothing serious.                                  |
" |                      8.5                                                    |
" |                      Fixed an 'undeclared variable' error that can occur    |
" |                      when the number of lines in a small (about 5 lines)    |
" |                      file goes down to fewer.                               |
" |                      8.4                                                    |
" |                      Finally made the 'timer' well-behaved by detecting if  |
" |                      the cursor was on the first column of a line in the    |
" |                      case where there were too few lines to move up/down.   |
" |                      The cursor now moves *right* if you're at column 1     |
" |                      (first column), *not* left as before. The cursor now   |
" |                      moves left only if your cursor is *not* on column 1,   |
" |                      rather than indiscriminately move left Anyway, beeping/|
" |                      flashing should now almost go away. There is a case    |
" |                      that I can't handle and that's when there is only one  |
" |                      character in the file, in which case the editor beep/  |
" |                      flash once as it tries to do a 'timer' but there isn't |
" |                      any space to move 'right' to, but hopefully that       |
" |                      shouldn't be too bad.                                  |
" |                      8.3                                                    |
" |                      There was a bug with the 'timer' routine which made vim|
" |                      flash/beep if there was not enough lines above to      |
" |                      temporarily move the cursor to (this causing the       |
" |                      'timer'.) This has now been fixed. If there are too    |
" |                      few lines the timer will try to move left and right    |
" |                      instead of up and down. There is a slight possibility  |
" |                      that the editor will beep at you if you are on the     |
" |                      first character or if there are no characters in the   |
" |                      file, but hopefully that should not be the case long   |
" |                      enough to bother. Also added a line set whichwrap=h,l  |
" |                      to minimise this flashing. If you like using this      |
" |                      script it is better to leave this on as it will        |
" |                      minimise this flashing/beeping.                        |
" | THU 29TH OCT 2009: o 8.2                                                    |
" |                      Removed an unecessary variable 'k' that was in the     |
" |                      'timer' routine.                                       |
" |                      8.1                                                    |
" |                      Corrected a slight glitch with the improved 'timer'    |
" |                      routine that happened if the cursor was bang in the    |
" |                      middle of the screen or the line above it. It got      |
" |                      confused because what had been true previously had     |
" |                      just changed. Now fixed. Did this by adding special    |
" |                      cases of where to move 'safely' if the cursor is a)    |
" |                      bang in the middle and b) directly *above* the middle. |
" |                      Did this using a 'middle' flag and an 'abovemiddle'    |
" |                      flag. Ugly but it does the job. (Sorry, but I'm not    |
" |                      Donald Knutz.)                                         |
" |                      8.0                                                    |
" |                      Fixed a slight glitch with the 'timer' that made Vim   |
" |                      indiscriminately move the cursor right and then left   |
" |                      which occasionally (depending on where your cursor was)|
" |                      made the screen either scroll or flash nastily,        |
" |                      depending on what you had set 'whichwrap' to. This     |
" |                      has now been fixed. The 'timer' hack is a bit more     |
" |                      intelligent. It now moves only where nothing would     |
" |                      change too drastically or cause a beep/flashed window. |
" | MON 26TH OCT 2009: o 7.9                                                    |
" |                      Still having difficulty with the Normal. It's a fine   |
" |                      compromise between Glare and visibility.  Just         |
" |                      brightened Normal up an infinetessimal amount just to  |
" |                      improve that legibility whilst hopefully keeping the   |
" |                      illusion of smoothness smooth. Sorry to keep changing  |
" |                      things but it's a trial an error process. I will get it|
" |                      right one day, if necessary I may have to re-write the |
" |                      custom function to handle the specific visibility      |
" |                      issues of the Normal element.                          |
" | SUN 25TH OCT 2009: o 7.8                                                    |
" |                      Made the Normal look still a bit less glary. Still     |
" |                      struggling with this because there is no comfort zone, |
" |                      it's all or nothing, due to it being a main element.   |
" |                      (The background uses this element to get it's colour   |
" |                      from.)                                                 |
" |                    o 7.7                                                    |
" |                      Made one final tweak to the light background boundary  |
" |                      of Statement which still makes me squint to focus a    |
" |                      tad, so added just a feathering of light background    |
" |                      brightness to bring out the element. I feel this won't | 
" |                      be a problem any more. Sorry for all the changes.      |
" |                      7.6                                                    |
" |                      Spotted the visibility of Visual (the colour Vim uses  |
" |                      to select text) at darkest background light nearly     |
" |                      invisible - fixed that. Further refined the boundary of|
" |                      Statement at light end of background spectrum. Not only|
" |                      is it pretty now but works well.                       |
" |                      7.5                                                    |
" |                      Improved the visibility of Statement a bit more. It    |
" |                      was still looking a bit blurry at the lighter back-    |
" |                      ground. Anyway, it looks very pretty now.              |
" | SAT 24TH OCT 2009: o 7.4                                                    |
" |                      Went carefuly over Statement as this was changing      |
" |                      too agressively over the difficult visibility patch.   |
" |                      Originally the visibility-tweaking functions were not  |
" |                      as detailed so this reflected the limited options      |
" |                      there were then. Now Statement fully uses 'ramped-     |
" |                      brighten-ups' that as this term suggests brighten-up   |
" |                      backgrounds to correct visibility problems in a smooth |
" |                      (not abrupt) manner                                    |
" |                      7.3                                                    |
" |                      Tried my best to tune-up the Normal syntax element     |
" |                      which is unique because it's background is the global  |
" |                      background. Other elements can have their backgrounds  |
" |                      "fixed-up" using various tricks to correct their       |
" |                      visibility but Normal can't. Typically Normal is the   |
" |                      keywords and most of the variable names in Javascript. |
" |                      Other languages rely on it to a lesser degree, but     |
" |                      still can be quite heavily dependent on it. The better |
" |                      supported languages (like PHP) rely on it a lot less.  |
" |                      Anyway, if you use Changing Colour script now Normal   |
" |                      doesn't stand-out glaring too much but while still     |
" |                      remaining visible at both bright and dark backgrounds. |
" |                      It's quite a subtle compromise between glare and       |
" |                      visibility this one and i hope i got it right.         |
" | THU 22ND OCT 2009: o 7.2                                                    |
" |                      Removed a number that was being output to the status   |
" |                      line by the new code to cause the script to change     |
" |                      colour wihtout waiting for user intervention.          |
" |                      7.1                                                    |
" |                      Added some lines that enable the script to constantly  |
" |                      change colour, not wait until the text is changed or   |
" |                      the user moves the cursor. That way it really acts like|
" |                      it's supposed to, updating the colours subtly as the   |
" |                      minutes go by every minute, keeping it interesting,    |
" |                      reducing eye-strain and informaing you of time going   |
" |                      by.                                                    | 
" | SAT 29TH AUG 2009: o 7.0                                                    |
" |                      Made the script so that when you go into Insert mode   |
" |                      the background inverts using the 'next' colour in      |
" |                      the 6-colour half-hour colour rotation. That way       |
" |                      whenever you go into Insert mode the background will   |
" |                      turn into the background in 30 minutes' time in Normal |
" |                      mode giving you a quick 'peek' into the next half-hour.|
" |                      Previously the background would change just into       |
" |                      whatever the colour was on the other half hour of the  |
" |                      current hour.                                          |
" |                    o 6.9                                                    |
" |                      Corrected a slight visibility glitch in Special.       |
" | FRI 28TH AUG 2009: o 6.8                                                    |
" |                      Used a similar technique to correct a not-quite-conti  |
" |                      uous StatusLine and StatusLineNC and for the Normal.   |
" |                      Before StatusLine and StatusLineNC would suddenly      |
" |                      flip into black or white when visibility got poor to   |
" |                      avoid the visibility problem but this now works the    |
" |                      same way as Normal was made to in revision 6.3.        |
" |                    o 6.7                                                    |
" |                      Made a fix so that the background now lightens         |
" |                      and darkens, lightens and darkens, etc.. using a       |
" |                      six-color rotation  different pastel shades: light-    |
" |                      yellow, light-green, light-red, light-blue, light cyan,|
" |                      and light magenta. This means that the background now  |
" |                      lightens-up using a certain shade, darkens down in     |
" |                      another shade, then lightens-up in yet another, and so |
" |                      on. for a total of six different colours over 3 hours. |
" |                      I've tried to make it so that the background simulates |
" |                      the way the real sky colours at morning time and then  |
" |                      colours at evening time and then again at morning time,|
" |                      and so on.                                             |
" | THU 27TH AUG 2009: o 6.6                                                    |
" |                    . A bit of icing on the cake really, made the cursor     |
" |                      turn a nice primary red at the highest background      |
" |                      lightness. It's better than before as before it just   |
" |                      turned a darker yellow and this was dull and           |
" |                      unimaginative and didn't out. Now with the red         |
" |                      the cursor looks nice and strong at a lighter          |
" |                      background brightness.                                 |
" |                    o 6.5                                                    |
" |                    . Fined-tuned the visibility of Normal at lighter back-  |
" |                      grounds.                                               |
" | WED 26TH AUG 2009: o 6.4                                                    |
" |                    . The same as before but made the brightening work a     |
" |                      bit more 'blended-in' with the background, so as the   |
" |                      background lightens the Normal element kicks-in a bit  |
" |                      stronger with its own lightening so that it doesn't    |
" |                      get 'out-lightened' by the lighter background, while   |
" |                      at the same time Normal doesn't lighten too strongly   |
" |                      at darker background ranges to compensate for the fact |
" |                      that contrast is better anyway. Now Normal blends in   |
" |                      very nicely throughout all background lightnesses.     |
" |                    o 6.3                                                    |
" |                    . Removed the jarring black vs. white effect that the    |
" |                      Normal identifier had, now this simply brightens a bit |
" |                      when the background and it start to clash. It now looks|
" |                      reasonably pleasing to the eye as time passes, rather  |
" |                      than abruptly change from black->white and vice versa. |
" |                      6.2                                                    |
" |                    . For some reason the Identifiers got some bad values,   |
" |                      not very optimal. Must have had a bad day. This is     |
" |                      quite nice, tuned in at light and dark background      |
" |                      ranges. Looks as it should. Sorry about this.          |
" | TUE 25TH AUG 2009: o 6.1                                                    |
" |                    . Realised that the LineNr highlight item was the same   |
" |                      as Normal and that this looks boring. Have changed     |
" |                      this now to look more of a pale or dark blue depending |
" |                      on which looks best relative the background.           |
" |                    o 6.0                                                    |
" |                    . Had to darken the Identifier around the area where it  |
" |                      looks bad with the background. I had made this weaker  |
" |                      but it's too weak. This is fixed and now it's quite    |
" |                      nice, not too dark - you can see the green- but darker.|
" |                      5.9                                                    |
" |                    . My mistake got some bad values into Identifier somehow |
" |                      this has been fixed sorry. Was getting super-dark      |
" |                      instead of just turning a slightly darker shade of     |
" |                      green where the visibility gets bad with the           |
" |                      background.                                            |
" |                      5.8                                                    |
" |                    . Added some colours to the Javascript colour coding     |
" |                      as it looks very poor otherwise. Constant numbers      |
" |                      in JavaScript now behave the same as PHP Constants.    |
" |                      Javascript brackets now behave the same as PHP         |
" |                      punctuation symbols.                                   |
" | THU  6TH AUG 2009: o 5.7                                                    |
" |                    . Found that making Visual a bit milder made it a bit    |
" |                      difficult to read sometimes so made it a little bit    |
" |                      stronger so hopefully it still doesn't obstruct text   |
" |                      but is clear enough to see.                            |
" |                      5.6                                                    |
" |                    . Still experienced problems with visibility of 'Directo-|
" |                      ry', not noticed before because Directory does not     |
" |                      often appear - occurs inside the :Ex command (File     |
" |                      Browse). Now this looks both beautiful and easy to see |
" |                      at any lightness. Made Visual a bit less strong as this|
" |                      was previously was blocking out the text. Now it's     |
" |                      only a shade different to make sure the selected text  |
" |                      text stays visible.                                    |
" |                      5.5                                                    |
" |                    . Cured disastrous visibility failure of Directories in  |
" |                      the file browser command :Ex. Directory was almost     |
" |                      totally invisible at a particular background lightness |
" |                      as it happened exactly when I needed to see what       |
" |                      directory I was in. Update to this script now and this |
" |                      wont happen to you.                                    |
" | FRI 31TH JUL 2009: o 5.4                                                    |
" |                    . Stretched the 'lighting-up time' of Identifier a bit   |
" |                      later into the darkness. The 'lighting-up' was         |
" |                      coming-up slightly before it 'got really dark', so this|
" |                      looked silly. Now Identifier feels more like it lights |
" |                      up at exactly the correct time.                        |
" | THU 30TH JUL 2009: o 5.3                                                    |
" |                      Fine-tuned the visibility protection of Comment so that|
" |                      it now looks great around the dark background area.    |
" |                      Previously was looking a bit muggy. Stretched this     |
" |                      protection exactly around the perceptional boundary    |
" |                      area and fined-tuned the 'back-darkening' effect at    |
" |                      this lower range as well so that it now just does that |
" |                      job it should do.                                      |
" |                    o VER 5.2                                                |
" |                    . Made the backgrounds fade very smoothly, as i found    |
" |                      that there were still inconsistencies. They have now   |
" |                      have been fixed. The colours of the background now     |
" |                      blend smoothly from dark to light. Fixed sudden        |
" |                      brightening that occurred of the of background. Now the|
" |                      transition is sweet. Also the background stays         |
" |                      consistently coloured. Previously it would go dark     |
" |                      green and suddently change to a very light-red colour. |
" |                      A slight glitch that is now corrected by manipulating  |
" |                      R,G,B values better. Hour 1: dark-brown to light       |
" |                      yellow. Hour 2: dark-green to light-green. Hour 3: dark|
" |                      grey-purple to light-pink.                             |
" |                    o VER 5.1                                                |
" |                    . Made Identifier have the 'lights on' look a bit later  |
" |                      so that when this happens seems about the right time   |
" |                      with relation to how dark the background is. Previously|
" |                      Idenfier became 'lights on' well before the background |
" |                      was really that dark and this looked a bit stupid.     |
" |                    o VER 5.0                                                |
" |                    . Realised that the background was not continuous on the |
" |                      second hour. Made the background fading continuous, so |
" |                      it looks like there's continuity. Hour 1 background    |
" |                      fades smoothly between dark-blue to light-yellow. Hours|
" |                      2 it goes smoothly from dark-green to a lighter green. |
" |                      Finally hour 3 the background goes smoothly from a     |
" |                      dark-red to a light pinky colour. I feel that whilst   |
" |                      these are not the prettiest shades ever, that they are |
" |                      at least doing the job. I need to try these out fully  |
" |                      to get a feel for how they're working and hence get    |
" |                      better shades, but for now they're working. (Look      |
" |                      smooth). Watch this space for better ideas.            |
" |                    o VER 4.9                                                |
" |                    . made the visibility-protection of Identifier a bit less|
" |                      glary. Previously i was trying to use brightening of   |
" |                      the background to improve visibility but it was too    |
" |                      strong. This was my fault. I was trying to improve it. |
" |                      Apologies. I've now corrected this so that Identifier  |
" |                      remains remain nice and easy on the eyes as the back-  |
" |                      ground fades from dark-light and vice versa.           |
" | WED 29TH JUL 2009: o VER 4.8                                                |
" |                    . removed display of time. This is redundant now that the|
" |                      changing colours help you keep track of time better.   |
" |                    o VER 4.7                                                |
" |                    . made a slight boo-boo in that the speed being quicker  |
" |                      of the background changes also meant that the          |
" |                      frequency of the updates speeds up. Did not realise    |
" |                      this. My mistake, poor programmer here. Fixed it now so|
" |                      that by default the background updates only every      |
" |                      minute.                                                |
" |                    o VER 4.6                                                |
" |                    . changed the speed at which background shifts from light|
" |                      to dark and vice-versa so that instead of going        |
" |                      gradually from dark to light over the hour then back   |
" |                      in the next hour, the background now does so in a half |
" |                      hour slots so the same as happened over two hours      |
" |                      before now happens over one hour. The 'shaded          |
" |                      backgrounds' added in 4.2 keep it interesting as on    |
" |                      hour 1 the colour shades differently to what it does on|
" |                      hour 2, and again to what it does on hour 3. If you    |
" |                      feel this is too sudden stick to script version 4.5    |
" |                      as this version does this more gradually over 2-hour   |
" |                      slots.                                                 |
" |                    o VER 4.5                                                |
" |                    . whilst trying to de-saturate the lighter background    |
" |                      shades i seemed to get the math wrong and therefore    |
" |                      at certain ranges the background looks super-saturated.|
" |                      This is fixed now. The background is truly pastel      |
" |                      at all lighter background ranges, i fixed the math.    |
" |                    o VER 4.4                                                |
" |                    . made the higher backgrounds of the new differing       |
" |                      shades a bit less glary. Previously they were quite    |
" |                      saturated colours and didn't look nice. Now they're    |
" |                      tasteful shades of pastel. The hour 1-2 colours are    |
" |                      pastel yellow, hour 3-4 colours are cyan, and finally  |
" |                      the hours 5-6 colours are pastel pink.                 |
" |                    o VER 4.3                                                |
" |                    . made the Statement's danger-visibility zone wider      |
" |                      at darker backgrounds. This was not wide enough to     |
" |                      remain clear at the boundary of visibility-ok to       |
" |                      visibility not-ok area, but now Statement's visbility  |
" |                      protection area is extended a bit at the darker range  |
" |                      making it more visible there.                          |
" | TUE 28TH JUL 2009: o VER 4.2                                                |
" |                    . added a pleasant (i hope not too bad at least)         |
" |                      selection of background (shades) along with the        |
" |                      one that was there before. Now, on hour 1 the back-    |
" |                      ground sticks to a normal (looking from dark-light)    |
" |                      blue to light-yellow scheme, and on hour 2 as usual in |
" |                      reverse (same but going from light to dark), then on   |
" |                      hour 3 going to light again the background shades      |
" |                      green to light-blue, then in reverse on hour 4, then   |
" |                      finally on 5 going to light the background shades green|
" |                      to light-pink, then in reverse in reverse on hour 6.   |
" | MON 27TH JUL 2009: o VER 4.1                                                |
" |                    . for some reason i missed that at the very darkest      |
" |                      background Search was indistinguishable from the back- |
" |                      ground - messed this up, my own fault i apologise.     |
" |                      I focussed to narrowly on 'dark' and didn't go down    |
" |                      all the way down to black where Search got invisible   |
" |                      (or indistinguishable from the background, at any rate)|
" |                      This is now fixed.                                     |
" |                    o VER 4.0                                                |
" |                    . realised that syntax element 'Search' was almost       |
" |                      impossible to distinguish from general background      |
" |                      at darker backgrounds. Fixed this so that Search now   |
" |                      contrasts significantly from the general background    |
" |                      at dark backgrounds without being too strong.          |
" | THU 23RD JUL 2009: o VER 3.9                                                |
" |                    . went over visibility of Identifier at lighter          |
" |                      backgrounds. It was ok at the darker backgrounds,      |
" |                      but lighter backgrounds were adjusted wrongly, making  |
" |                      too much use of 'background-lightening' to bring out   |
" |                      the colour of Identifier. Darkened this down and now   |
" |                      it looks a lot more pleasant.                          |
" | TUE 21ST JUL 2009: o VER 3.8                                                |
" |                    . mildened-down the agressive dark-background            |
" |                      'enhancement' at the dark-background range of          |
" |                      Identifier. It feels a lot smoother now because        |
" |                      previously the darkening of the background effect      |
" |                      kicked-in too heavily resulting in it being            |
" |                      disorientating to look at. Now it just feels much      |
" |                      smoother.                                              |
" | SAT 11TH JUL 2009: o VER 3.7                                                |
" |                    . went over the contrast of Identifier at dark, medium,  |
" |                      and light levels of background. Previously looked      |
" |                      fuzzy in all areas. Contrast is quite strong now       |
" |                      enhanced with plentiful helpings of 'back-lighting' and|
" |                      'back-darkening' to bring out the green of the         |
" |                      Identifier.                                            |
" | FRI 10TH JUL 2009: o VER 3.6                                                |
" |                    . made a tiny correction to the length of time before    |
" |                      the Constant went into the clash-background 'danger'   |
" |                      area from dark to light, went ahead and delayed it     |
" |                      by one minute. The change although small compared to   |
" |                      other changes i've made recently changes the change    |
" |                      (no pun intended) from a somewhat 'deadening' looking  |
" |                      effect into as a lucid inversion of colour which is    |
" |                      more pleasing to look at.                              |
" |                    o VER 3.5                                                |
" |                    . made the transition into 'danger' area from dark->light|
" |                      of the Constant a bit more gradual so as to maintain   |
" |                      an overall illusion of progress. Previously the change |
" |                      had been abrupt (Constants went quite dark suddenly)   |
" |                      so this illusion was lost. To do this modified the     |
" |                      start and end times of the 'danger' area. Went ahead   |
" |                      and added new easeArea global variable to allow the    |
" |                      easing length to be controlled. This allowed me to     |
" |                      go ahead and create longer easing for the Constant from|
" |                      dark->light as well, again smoothing the change from   |
" |                      non-'danger' to 'danger'.                              |
" | THU 9TH JUL 2009:  o VER 3.4                                                |
" |                    . added fading effect to the way backlighting engages    |
" |                      so as background progresses darker->lighter or vice-   |
" |                      versa for some elements the backlighting doesn't       |
" |                      instantly 'kick-in' but becomes stronger gradually.    |
" |                      This affects Constant at darker background, Statement  |
" |                      and Identifier. Also strengthened the contrast of      |
" |                      StatusBar and StatusBarNC, as they were a bit blurry   |
" |                      at darker background tones.                            |
" | WED 8TH JUL 2009:  o VER 3.3                                                |
" |                    . made Constant look very pretty at lighter background   |
" |                      tones by adding dab of shadow, tuned-up as far as i    |
" |                      could the Constant visibility at lower-light           |
" |                      background and darker part of the clash background     |
" |                      area - where background makes text's colour hardest to |
" |                      to read.                                               |
" | TUE 7TH JUL 2009   o VER 3.2                                                |
" |                    . removed a lot of the 'glary' backlighting by making    |
" |                      the text color get darker                              |
" |                    . greatly improved visibility of Constant at darker      |
" |                      background colours without distorting the background   |
" |                      too much.                                              |
" |                    . greatly simplified the way RGBEl2 works, hence making  |
" |                      it easier to estimate how much adjustment text needs   |
" | MON 6TH JUL 2009:  o VER 3.1                                                |
" |                    . made the backlighting of Statement and Constant less   |
" |                      bright, it was overdone                                |
" | SUN 5TH JUL 2009:  o VER 3.0                                                |
" |                    . finally made Constant backlighting so that it          |
" |                      perfectly kicks in at darker background colours        |
" |                      backgrounds                                            |
" |                    . improved visibility around clash-background and just   |
" |                      below the clash-background area of Comment             |
" |                    o VER 2.9                                                |
" |                    . made backlighting for Statement in the clash-background|
" |                      area less bright.                                      |
" | SAT 4TH JUL 2009:  o VER 2.8                                                |
" |                    . darkened the back-darkening of Constant at the low end |
" |                      of the background spectrum, as it looks a bit fuzzy    |
" |                      otherwise.                                             |
" |                    o VER 2.7                                                |
" |                    . made a slight correction to the backlighting of the    |
" |                      Constant that was looking way to bright at the high    |
" |                      end of the background spectrum                         |
" |                    o VER 2.6                                                |
" |                    . extensively tuned-up the interplay of Statement,       |
" |                      Identifier, and specially Constant re. the changing    |
" |                      background colour. C64 fans will love some of the      |
" |                      funky colours at the darker end of the background      |
" |                      spectrum.                                              |
" | FRI 3RD JUL 2009:  o VER 2.5                                                |
" |                    . darkened background backlighting at the dark end of    |
" |                      Constant because it was too hard to read               |
" |                    . darkened background backlighting at the dark end of    |
" |                      Identifier as it was a little fuzzy                    |
" |                    o VER 2.4                                                |
" |                    . made statement backlighting effect less agressive      |
" |                    . made the Constant text colour blue, not brown, as there|
" |                      were too many other browns and it got repetitive       |
" |                    . added a dab more backlighting to Identifier and        |
" |                      darkened the text colour a shade                       |
" |                    . reversed the order of the revision history comments    |
" | THU 2ND JUL 2009   o VER 2.3                                                |
" |                    . made the Constant text colour more gradual change as it|
" |                      goes over the 'danger' area. Previously it went to jet |
" |                      black suddenly as the background went from dark to     |
" |                      light. It looked really silly. Now the colour is a     |
" |                      more nice dark-brown colour, not jet-black.  Tuned-in  |
" |                      the background 'down'-lighting of Constant at the dark |
" |                      boundary of the danger zone so it is exactly as        |
" |                      dark as it needs to be no more, and tuned-in the       |
" |                      actually in-the-danger-zone' background adjustment as  |
" |                      well so it brings out the new non-jet-black text colour|
" |                    o VER 2.2                                                |
" |                    . made the Constant background up-lighting a bit         |
" |                      stronger as it was previously overcorrected and made   |
" |                      *too* weak (oops!), and adjusted the 'dangerzone'      |
" |                      background lighting of the same element to be not quite|
" |                      as bright, so that it looks more tastefully done       |
" |                    o VER 2.1                                                |
" |                    . corrected slightly over-zealous background brightening |
" |                      in the lighter background of Constant highlight elem.  |
" |                    . improved the clarity of the explantion of what the     |
" |                      RGBEl4 function does                                   |
" |                    . removed variable s:oldhA that had originally been part |
" |                      of calculation for the timing of the change of colours,|
" |                      that gradually got replaced by the more accurate       |
" |                      s:oldactontime                                         |
" |                    . added a proper description of what s:oldactontime does |
" |                    . improved clarity of description of what g:changefreq   |
" |                      does                                                   |
" | SAT 13TH JUN 2009  o VER 2.0                                                |
" |                    . made standard change freq. 1 min, not too often to     |
" |                      annoy but often enough to remind you of time is passing|
" |                    o VER 1.9                                                |
" |                    . made it very easy for you to set your own preferred    |
" |                      frequency for the script to change the colour          |
" | FRI 12TH JUN 2009: o VER 1.8                                                |
" |		       . removed 'stopinsert' from au CursorHoldI               |
" |		         unintentionally left in                                |
" |		       . added comment to show how to remove invert effect      |
" | THU 11TH JUN 2009: o VER 1.7                                                |
" |		       . corrected slightly glary Identifier at low light       |
" | THU 4TH JUN 2009:  o VER 1.6                                                |
" |                    . brightened Constant and Identifier bgr. a tiny amount  |
" | WED 3RD JUN 2009:  o VER 1.5                                                |
" |                    . removed duplicate htmlComment* pair                    |
" |                    . improved comment to a nice balanced-out grey           |
" |                    o VER 1.4                                                |
" |                    . improve way bckgrnds. enhanced, corrected some mistakes|
" | TUE 2ND JUN 2009:  o VER 1.3                                                |
" |                    . added pretty frames around function descriptions       |
" |                    . created new entry for Directory element in grassy green|
" |                    . corrected bug: lo-lights not perfectly synch. wit. text|
" | TUE 2ND JUN 2009:  o VER 1.2                                                |
" |                    . Corrected Search element background was perm. yellow   |
" |                    . Considerably reduced clutter, shortened names, etc     |
" | MON 1ST JUN 2009:  o VER 1.1                                                |
" |                    . Put comment markers to ensure whole script include-oops|
" |                    . Corrected Question of element potential                |
" | WED 27TH MAY 2009: o VER 1.00                                               |
" +-----------------------------------------------------------------------------+

" +------------------------------------------------------------------------------+
" | The following static variable provide a way for the script to check if its   |
" | time that the muscle function should call vim's 'highlight' command to cause |
" | all the syntax elements colouring to change. A combination of this and       |
" | 'changefreq' (below) is used to determine final yes/no (it is time or not)   |
" +------------------------------------------------------------------------------+
let s:oldactontime=-9999

" +------------------------------------------------------------------------------+
" | This variable is used to control how often the script deems it's time to     |
" | 'progress' the colour (also see above). The higher the value the less often  |
" | it will do so, the lower the more often it will do so.  2880 is equivalnet   |
" | to every minute, 5760 every two minutes.                                     |
" +------------------------------------------------------------------------------+
let g:changefreq=2880

" +------------------------------------------------------------------------------+
" | The following variable is the size of the area below and above that zone that|
" | makes the text colour 'darken' to avoid clashing with the background. It     |
" | lasts around 2 minutes and during this time the text colour stays exactly    |
" | unmodified but the background is tweaked up or down to 'ease' visibility     |
" | while not drastically changing anything yet. This happens in that area known |
" | as the 'danger' area. The bigger this value the bigger that 'ease' period    |
" | is, with 7200 being around 2 minutes above and below 'danger' area.          |
" +------------------------------------------------------------------------------+
let g:easeArea=8200

"debug
"let g:mytime=16000
"let g:myhour=0

" +------------------------------------------------------------------------------+
" | The following routine causes a non-printing keypress to be generated when    |
" | the cursor has been idle, hence causing a kind of 'timer' function.  Replaces|
" | previous 'cusor-movement' based one that hacked around with the cursor but   |
" | causes too many problems. Courtesey of Yukihiro Nakadaira. Source:-          |
" | http://old.nabble.com/timer-revisited-td8816391.html.                        |
" +------------------------------------------------------------------------------+
let g:K_IGNORE = "\x80\xFD\x35"   " internal key code that is ignored
autocmd CursorHold * call Timer()
function! Timer()
  call feedkeys(g:K_IGNORE)
endfunction 

" +------------------------------------------------------------------------------+
" | Main RGBEl function, used to work out amount to offset RGB value by to avoid |
" | it clashing with the background colour.                                      |
" | Return value is modified or otherwise value (not modified if no clash).      |
" +------------------------------------------------------------------------------+
:function RGBEl2(RGBEl,actBgr,dangerBgr,senDar,senLig,adjust)
:	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
:		let whatdoyoucallit=a:dangerBgr-a:actBgr
:		if whatdoyoucallit<0
:			let whatdoyoucallit=-whatdoyoucallit
:		endif
:		let whatdoyoucallit=whatdoyoucallit/130
:		if whatdoyoucallit>255
:			let whatdoyoucallit=255
:		endif
:		let whatdoyoucallit=-whatdoyoucallit+255
:		let whatdoyoucallit=whatdoyoucallit*a:adjust
:		let whatdoyoucallit=whatdoyoucallit/800
:		let whatdoyoucallit=whatdoyoucallit+65
:		let adjustedValue=a:RGBEl-whatdoyoucallit
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | Main RGBEl for Normal (like RGBEl2 but brightens, not darkens - Normal is    |
" | a bit trickier because it is also where the general background is set        |
" +------------------------------------------------------------------------------+
:function RGBEl2a(RGBEl,actBgr,dangerBgr,senDar,senLig,loadj,hiadj)
:	let localEase = 0
:	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
:		let        progressFrom=a:dangerBgr-a:senDar
:		let        progressLoHi=a:actBgr-progressFrom
:		let            diffLoHi=(a:dangerBgr+a:senLig)-(a:dangerBgr-a:senDar)
:		let     progressPerThou=progressLoHi/(diffLoHi/1000)
:		let     ourinterestDiff=a:hiadj-a:loadj
:		let     weareScaleRatio=1000/ourinterestDiff
:		let            interest=progressPerThou/weareScaleRatio
:		let           interest2=interest+a:loadj
:		let       adjustedValue=a:RGBEl+interest2
:	elseif a:actBgr>=a:dangerBgr-a:senDar-localEase && a:actBgr<a:dangerBgr-a:senDar
:		let        progressFrom=a:dangerBgr-a:senDar-localEase
:		let        progressLoHi=a:actBgr-progressFrom
:		let            diffLoHi=(a:dangerBgr-a:senDar)-(a:dangerBgr-a:senDar-localEase)
:		let     progressPerThou=progressLoHi/(diffLoHi/1000)
:		let     ourinterestDiff=a:loadj
:		let     weareScaleRatio=1000/ourinterestDiff
:		let            interest=progressPerThou/weareScaleRatio
:		let           interest2=interest
:		let       adjustedValue=a:RGBEl+interest2
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | Special RGBEl function for cases that needed special care. It provides       |
" | more control over the text's high or low lighting in the danger visibility   |
" | zone.                                                                        |
" +------------------------------------------------------------------------------+
:function RGBEl2b(RGBEl,actBgr,dangerBgr,senDar,senLig,adjust1,adjust2,adjust3)
:	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
:		let        progressFrom=a:dangerBgr-a:senDar
:		let        progressLoHi=a:actBgr-progressFrom
:		let            diffLoHi=(a:dangerBgr+a:senLig)-(a:dangerBgr-a:senDar)
:		let     progressPerThou=progressLoHi/(diffLoHi/1000)
:		if progressPerThou<500
:			let     ourinterestDiff=a:adjust2-a:adjust1
:			let     weareScaleRatio=1000/ourinterestDiff
:			let            interest=progressPerThou/weareScaleRatio
:			let           interest2=interest+a:adjust1
:			let      adjustedAdjust=interest2
:		else
:			let     ourinterestDiff=a:adjust3-a:adjust2
:			let     weareScaleRatio=1000/ourinterestDiff
:			let            interest=progressPerThou/weareScaleRatio
:			let           interest2=interest+a:adjust2
:			let      adjustedAdjust=interest2
:		endif
:		let whatdoyoucallit=a:dangerBgr-a:actBgr
:		if whatdoyoucallit<0
:			let whatdoyoucallit=-whatdoyoucallit
:		endif
:		let whatdoyoucallit=whatdoyoucallit/130
:		if whatdoyoucallit>255
:			let whatdoyoucallit=255
:		endif
:		let whatdoyoucallit=-whatdoyoucallit+255
:		let whatdoyoucallit=whatdoyoucallit*adjustedAdjust
:		let whatdoyoucallit=whatdoyoucallit/800
:		let whatdoyoucallit=whatdoyoucallit+65
:		let adjustedValue=a:RGBEl-whatdoyoucallit
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | RGBEl function for cursor to work out amount to offset RGB component to stop |
" | it from clashing with the background colour.                                 |
" | Return value is modified or otherwise value (not modified if no clash).      |
" +------------------------------------------------------------------------------+
:function RGBEl3(RGBEl,actBgr,dangerBgr,adj)
:	let diff=a:actBgr-a:dangerBgr
:	if diff<0
:		let diff=-diff
:	endif
:	if diff<8000
:		let adjustedValue=a:RGBEl-a:adj
:		if adjustedValue<0
:			let adjustedValue=0
:		endif
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | RGBEl function used to work out offsetting for RGB components pertaining to  |
" | a background, i.e. the bit that says guibg= of the vim highlight command.    |
" | Background is handled different to foreground so it needs another function.  |
" | You can tell this RGBEl function what to do with the background if RGB value |
" | is *just* below the 'danger' general background, and above it. In each case  |
" | you can tell it to brighten or darken the passed RGB value. (darkAdj,        |
" | lghtAdj params.) Positive values, (e.g. 40) add brightness, nagative values  |
" | remove it. Special cases 99 and -99 adds does this in a 'default' measure.   |
" | You can also tell the function what to do if the RGB value is right inside   |
" | the danger zone; not to be confused with darkAdj & lghtAdj that mean the     |
" | two end tips outside of the danger area. This bit is the danger area itself, |
" | the low-visisibility area, the 'danger zone'. (dangerZoneAdj) It works the   |
" | same, a positive value causes background to brighten, a negative to darken.  |
" | Like darkAdj & lghtAdj, you can also specify default 'brighten' or 'darken', |
" | 99 or -99 respectively, but if you're not happy with the default just fine   |
" | tune it exactly as you would like it to look exactly as you do with darkAdj  |
" | & lghtAdj. Use this if you find using the normal foreground text colour      |
" | modification by itself (RGBEl2 function) doesn't cut it. Text still looks    |
" | blurry over a certain background colour even after you've adjusted the danger|
" | adjustment parameters available in RGBEl2. Normally I found darkening text   |
" | with RGBEl2 adjustment params makes the text 'visible' over danger zone but  |
" | in some cases it wasn't up to it, so I added this param: 'dangerZoneAdj'.    |
" | This allows you to 'fudge' the background colour up and down as desired until|
" | you're happy with the result.                                                |
" | Return value is either the up or down-shifted RGB background element if the  |
" | element falls just outside the 'danger' boundary, a shifted-up RGB element   |
" | if the value is fully inside the danger boundary (and you set dangerZoneAdj) |
" | or simply the same as you pass if the value you pass is outside the danger   |
" | zone AND the outer boundary ring of the 'danger zone'.                       |
" +------------------------------------------------------------------------------+
:function RGBEl4(RGBEl,actBgr,dangerBgr,senDar,senLig,darkAdjLo,darkAdjHi,lghtAdjLo,lghtAdjHi,dangerZoneAdj)
:	let darkAdjLo=a:darkAdjLo
:	let darkAdjHi=a:darkAdjHi
:	let lghtAdjLo=a:lghtAdjLo
:	let lghtAdjHi=a:lghtAdjHi
:	if a:darkAdjLo==99
:		let darkAdjLo=11
:	endif
:	if a:darkAdjLo==-99
:		let darkAdjLo=-11
:	endif
:	if a:darkAdjHi==99
:		let darkAdjHi=11
:	endif
:	if a:darkAdjHi==-99
:		let darkAdjHi=-11
:	endif
:	if a:lghtAdjLo==99
:		let lghtAdjLo=11
:	endif
:	if a:lghtAdjLo==-99
:		let lghtAdjLo=-11
:	endif
:	if a:lghtAdjHi==99
:		let lghtAdjHi=11
:	endif
:	if a:lghtAdjHi==-99
:		let lghtAdjHi=-11
:	endif
:	let dangerZoneAdj=a:dangerZoneAdj
:	if a:dangerZoneAdj==99
:		let dangerZoneAdj=15
:	endif
:	if a:dangerZoneAdj==-99
:		let dangerZoneAdj=-15
:	endif
:	let adjustedValue=a:RGBEl
:	if a:actBgr>=a:dangerBgr-a:senDar-g:easeArea && a:actBgr<a:dangerBgr-a:senDar
:		let        progressFrom=a:dangerBgr-a:senDar-g:easeArea
:		let        progressLoHi=a:actBgr-progressFrom
:		let            diffLoHi=darkAdjHi-darkAdjLo
:		let  scaledProgressLoHi=diffLoHi*progressLoHi
:		let       adjustedValue=a:RGBEl+darkAdjLo+(scaledProgressLoHi/g:easeArea)
:	endif
:	if a:actBgr>a:dangerBgr+a:senLig && a:actBgr<=a:dangerBgr+a:senLig+g:easeArea
:		let        progressFrom=a:dangerBgr+a:senLig
:		let        progressLoHi=a:actBgr-progressFrom
:		let            diffLoHi=lghtAdjHi-lghtAdjLo
:		let  scaledProgressLoHi=diffLoHi*progressLoHi
:		let       adjustedValue=a:RGBEl+lghtAdjLo+(scaledProgressLoHi/g:easeArea)
:	endif
:	if a:actBgr>=(a:dangerBgr-a:senDar) && a:actBgr<=(a:dangerBgr+a:senLig) && dangerZoneAdj
:		let adjustedValue=adjustedValue+dangerZoneAdj
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction

" +------------------------------------------------------------------------------+
" | Special case of RGBEl function used particularly for the Normal highlight    |
" | element which obviously needs to be stronger because it's background cannot  |
" | be 'shifted' in bad visibility cases because Normal also happens to be the   |
" | the general background vim uses.                                             |
" +------------------------------------------------------------------------------+
:function RGBEl5(RGBEl,actBgr,dangerBgr,senDar,senLig)
:	if a:actBgr>=a:dangerBgr-a:senDar && a:actBgr<=a:dangerBgr+a:senLig
:		let adjustedValue=255
:	else
:		let adjustedValue=a:RGBEl
:	endif
:	if a:actBgr>=(a:dangerBgr+a:senLig)-21000 && a:actBgr<=a:dangerBgr+a:senLig
:		let adjustedValue=0
:	endif
:	if adjustedValue<0
:		let adjustedValue=0
:	endif
:	if adjustedValue>255
:		let adjustedValue=255
:	endif
:	return adjustedValue
:endfunction 

" +------------------------------------------------------------------------------+
" | This is a simple cut-off function disallowing values <0 and >255             |
" +------------------------------------------------------------------------------+
:function RGBEl6(RGBEl)
:	let result=a:RGBEl
:	if a:RGBEl<0
:		let result=0
:	endif
:	if a:RGBEl>255
:		let result=255
:	endif
:	return result
:endfunction

" +------------------------------------------------------------------------------+
" | This variable allows highlight to be inverted, i.e higher time = darker      |
" +------------------------------------------------------------------------------+
let highLowLightToggle=0

" +------------------------------------------------------------------------------+
" | Muscle function, calls vim highlight command for each element based on the   |
" | time into the current hour.                                                  |
" +------------------------------------------------------------------------------+
:function SetHighLight(nightorday)
:	let todaysec=((localtime()%(60*60)))*24
:	if exists("g:mytime")
:		let todaysec=g:mytime
:	endif
: 	let nightorday=a:nightorday
:	if nightorday==1
:		if todaysec<43199
:			let todaysec=-todaysec*2+86399
:			let dusk=0
:		else
:			let todaysec=(todaysec-43200)*2
:			let dusk=1
:		endif
:	else
:		if todaysec<43199
:			let todaysec=todaysec*2
:			let dusk=0
:		else
:			let todaysec=-todaysec*2+172799
:			let dusk=1
:		endif
:	endif
:	if exists("g:myhour")
:		let myhour=g:myhour
:	else
:		let myhour=(localtime()/(60*60))%3
:	endif
:	if (myhour==0 && dusk==0 && nightorday==0) || (myhour==2 && dusk==1 && nightorday==1)
:		let adjBG1=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:		let adjBG1A=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:		let adjBG2=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:	endif
:	if (myhour==0 && dusk==1 && nightorday==0) || (myhour==0 && dusk==0 && nightorday==1)
:		let adjBG1=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:		let adjBG1A=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:		let adjBG2=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:	endif
:	if (myhour==1 && dusk==0 && nightorday==0) || (myhour==0 && dusk==1 && nightorday==1)
:		let adjBG1=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:		let adjBG1A=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:		let adjBG2=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:	endif
:	if (myhour==1 && dusk==1 && nightorday==0) || (myhour==1 && dusk==0 && nightorday==1)
:		let adjBG1=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:		let adjBG1A=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:		let adjBG2=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:	endif
:	if (myhour==2 && dusk==0 && nightorday==0) || (myhour==1 && dusk==1 && nightorday==1)
:		let adjBG1=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:		let adjBG1A=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:		let adjBG2=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:	endif
:	if (myhour==2 && dusk==1 && nightorday==0) || (myhour==2 && dusk==0 && nightorday==1)
:		let adjBG1=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:		let adjBG1A=(todaysec<67000)?todaysec/420:(todaysec-43200)/271+80
:		let adjBG2=(todaysec<67000)?todaysec/380:(todaysec-43200)/271+96
:	endif
:	let whiteadd=(todaysec-60000)/850
:	if whiteadd>0
:		let adjBG1=adjBG1+whiteadd
:		if adjBG1>255
:			let adjBG1=255
:		endif
:		let adjBG1A=adjBG1A+whiteadd
:		if adjBG1A>255
:			let adjBG1A=255
:		endif
:		let adjBG2=adjBG2+whiteadd
:		if adjBG2>255
:			let adjBG2=255
:		endif
:	else
:		let whiteadd=0
:	endif
:	let adjBG3=(adjBG1-32>=32)?adjBG1-8:adjBG1+8
:	let adjBG4=(adjBG1-32>=32)?adjBG1-8:adjBG1+8
:       let hA=printf("highlight Normal guibg=#%02x%02x%02x",					adjBG1,adjBG1A,adjBG2)
:       let hA1=printf("highlight Folded guibg=#%02x%02x%02x guifg=#%02x%02x%02x",		adjBG1,adjBG1,adjBG4,adjBG1,adjBG1,adjBG4)
:       let hA2=printf("highlight CursorLine guibg=#%02x%02x%02x",				adjBG3,adjBG3,adjBG1) 
:       let hA3=printf("highlight NonText guibg=#%02x%02x%02x guifg=#%02x%02x%02x",		adjBG3,adjBG1,adjBG1,adjBG3,adjBG1,adjBG1)  
:       let hA4=printf("highlight LineNr guibg=#%02x%02x%02x",					adjBG1,adjBG3,adjBG1)
:	let adj1=	RGBEl4(adjBG1-30,							todaysec,0,0,10000,20,20,40,20,40)
:	let adj2=	RGBEl4(adjBG1A-10,							todaysec,0,0,10000,20,20,40,20,40)
:	let adj3=	RGBEl4(adjBG2+10,							todaysec,0,0,10000,20,20,40,20,40)
:       let hA5=printf("highlight Search guibg=#%02x%02x%02x",					adj1,adj2,adj3) 
:	let adj1=	RGBEl2(adjBG1,								todaysec,86399,4000,1,40)
:	let adj2=	RGBEl2(adjBG1A+30,							todaysec,86399,4000,1,40)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40)
:	let hA6=printf("highlight DiffAdd guibg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let adj1=	RGBEl2(adjBG1+30,							todaysec,86399,4000,1,40)
:	let adj2=	RGBEl2(adjBG1A,								todaysec,86399,4000,1,40)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40)
:	let hA7=printf("highlight DiffDelete guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1=	RGBEl2(adjBG1+30,							todaysec,86399,4000,1,40)
:	let adj2=	RGBEl2(adjBG1A+30,							todaysec,86399,4000,1,40)
:	let adj3=	RGBEl2(adjBG2,								todaysec,86399,4000,1,40)
:	let hA8=printf("highlight DiffChange guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1=	RGBEl2(adjBG1,								todaysec,86399,4000,1,40)
:	let adj2=	RGBEl2(adjBG1A,								todaysec,86399,4000,1,40)
:	let adj3=	RGBEl2(adjBG2+30,							todaysec,86399,4000,1,40)
:	let hA9=printf("highlight DiffText guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1	=RGBEl2a((-todaysec+86400)/338/4+160,					todaysec,50000,6000,16000,-60,-38)
:	let adj2	=RGBEl2a((-todaysec+86400)/338/4+76,					todaysec,50000,6000,16000,-60,-38)
:	let adj3	=RGBEl2a((-todaysec+86400)/338/4+23,					todaysec,50000,6000,16000,-60,-38)
:	let adj4	=RGBEl4(adjBG1,								todaysec,50000,6000,16000,-5,-10,-2,0,-4)
:	let adj5	=RGBEl4(adjBG1A,							todaysec,50000,6000,16000,-5,-10,-2,0,-4)
:	let adj6	=RGBEl4(adjBG2,								todaysec,50000,6000,16000,-5,-10,-2,0,-4)
:	let hB=printf("highlight Statement guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adjBG5=(todaysec<43200)?todaysec/338/2:todaysec/450+63
:	let hB1=printf("highlight VertSplit guifg=#%02x%02x%02x",				adjBG3,adjBG3,adjBG5)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+40,					todaysec,44000,8000,20000,100)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+54,					todaysec,44000,8000,20000,100)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+80,					todaysec,44000,8000,20000,100)
:       let hB2=printf("highlight LineNr guifg=#%02x%02x%02x",					adj1,adj2,adj3)  
:	let adj1=	RGBEl2((-todaysec+86400)/250/2+0,					todaysec,46500,15000,13000,112)
:	let adj2=	RGBEl2((-todaysec+86400)/250/2+76,					todaysec,46500,15000,13000,112)
:	let adj4=	RGBEl4(adjBG1,								todaysec,46500,15000,13000,-6,-13,-3,-2,5)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,46500,15000,13000,-6,-13,-3,-2,5)
:	let adj6=	RGBEl4(adjBG2,								todaysec,46500,15000,13000,-6,-13,-3,-2,5)
:	let hC=printf("highlight Constant guifg=#%02x%02x%02x guibg=#%02x%02x%02x",			adj1,adj1,adj2,adj4,adj5,adj6)
:	let hC1=printf("highlight JavaScriptValue guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj1,adj2,adj4,adj5,adj6)
:	let adj1=	RGBEl2a((-todaysec+86400)/338/2+110,					todaysec,32000,4200,38000,-146,-32)
:	let adj2=	RGBEl2a((-todaysec+86400)/338/2+64,					todaysec,32000,6600,38000,-146,-32)
:	let adj3=	RGBEl2a((-todaysec+86400)/338/2,					todaysec,32000,0100,38000,-146,-32)
:	let hD=printf("highlight Normal guifg=#%02x%02x%02x gui=NONE",				adj1,adj2,adj3)
:	let adj1=	RGBEl2((-todaysec+86400)/270/2+35,					todaysec,57000,9000,20000,70)
:	let adj2=	RGBEl2((-todaysec+86400)/270/2+103,					todaysec,57000,9000,20000,70)
:	let adj3=	RGBEl2((-todaysec+86400)/270/2,						todaysec,57000,9000,20000,70)
:	let adj4=	RGBEl4(adjBG1,								todaysec,57000,9000,20000,-5,-10,-5,-3,4)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,57000,9000,20000,-5,-10,-5,-3,4)
:	let adj6=	RGBEl4(adjBG2,								todaysec,57000,9000,20000,-5,-10,-5,-3,4)
:	let hE=printf("highlight Identifier guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,43000,5000,16000,39)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,43000,5000,16000,39)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+140,					todaysec,43000,5000,16000,39)
:	let adj4=	RGBEl4(adjBG1,								todaysec,43000,5000,16000,-99,-99,99,99,99)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,43000,5000,16000,-99,-99,99,99,99)
:	let adj6=	RGBEl4(adjBG2,								todaysec,43000,5000,16000,-99,-99,99,99,99)
:	let hF=printf("highlight PreProc guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/4+192,					todaysec,60500,14000,19000,40)
:	let adj2=	RGBEl2((-todaysec+86400)/338/4+100,					todaysec,60500,14000,19000,40)
:	let adj3=	RGBEl2((-todaysec+86400)/338/4+160,					todaysec,60500,14000,19000,40)
:	let adj4=	RGBEl4(adjBG1,								todaysec,60500,14000,19000,-99,-99,-99,-99,-4)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,60500,14000,19000,-99,-99,-99,-99,-4)
:	let adj6=	RGBEl4(adjBG2,								todaysec,60500,14000,19000,-99,-99,-99,-99,-4)
:	let hG=printf("highlight Special guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let hG1=printf("highlight JavaScriptParens guifg=#%02x%02x%02x gui=bold guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+120,					todaysec,47000,3000,14000,64)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+10,					todaysec,47000,3000,14000,64)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+80,					todaysec,47000,3000,14000,64)
:	let adj4=	RGBEl4(adjBG1,								todaysec,47000,3000,14000,-99,-99,-99,-99,99)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,47000,3000,14000,-99,-99,-99,-99,99)
:	let adj6=	RGBEl4(adjBG2,								todaysec,47000,3000,14000,-99,-99,-99,-99,99)
:       let hH=printf("highlight Title guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6) 
:	let adj1=	RGBEl2b((-todaysec+86400)/338/4+110,					todaysec,50000,5000,22000,40,0,-300)
:	let adj2=	RGBEl2b((-todaysec+86400)/338/4+110,					todaysec,50000,5000,22000,40,0,-300)
:	let adj3=	RGBEl2b((-todaysec+86400)/338/4+110,					todaysec,50000,5000,22000,40,0,-300)
:	let adj4=	RGBEl4(adjBG1,								todaysec,50000,5000,22000,-5,-18,0,0,-3)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,50000,5000,22000,-5,-18,0,0,-3)
:	let adj6=	RGBEl4(adjBG2,								todaysec,50000,5000,22000,-5,-18,0,0,-3)
:	let hI=printf("highlight Comment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hI1=printf("highlight htmlComment guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hI2=printf("highlight htmlCommentPart guifg=#%02x%02x%02x guibg=#%02x%02x%02x",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl6(todaysec/338+70							)
:	let adj2=	RGBEl6(todaysec/338+30							)
:	let adj3=	RGBEl6(todaysec/338-100							)
:	let adj4=	RGBEl2a((-todaysec+86400)/338/2+70,					todaysec,35000,15000,14000,60,120)
:	let adj5=	RGBEl2a((-todaysec+86400)/338/2+60,					todaysec,35000,15000,14000,60,120)
:	let adj6=	RGBEl2a((-todaysec+86400)/338/2+0,					todaysec,35000,15000,14000,60,120)
:	let hJ=printf("highlight StatusLine guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold",	adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl6(todaysec/338+70							)
:	let adj2=	RGBEl6(todaysec/338+60							)
:	let adj3=	RGBEl6(todaysec/338-100							)
:	let adj4=	RGBEl2a((-todaysec+86400)/338/2+70,					todaysec,20000,10000,14000,40,120)
:	let adj5=	RGBEl2a((-todaysec+86400)/338/2+0,					todaysec,20000,10000,14000,40,120)
:	let adj6=	RGBEl2a((-todaysec+86400)/338/2+0,					todaysec,20000,10000,14000,40,120)
:	let hK=printf("highlight StatusLineNC guibg=#%02x%02x%02x guifg=#%02x%02x%02x gui=bold",adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2,						todaysec,37000,27000,20000,40)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+20,					todaysec,37000,27000,20000,40)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+80,					todaysec,37000,27000,20000,40)
:	let adjBG6=(adjBG5-32>=0)?adjBG5-32:0
:	let hM=printf("highlight PMenu guibg=#%02x%02x%02x",					adjBG3,adjBG3,adjBG1)
:	let hN="highlight PMenuSel guibg=Yellow guifg=Blue"
:	let adj1=	RGBEl2(adjBG1+40,							todaysec,86399,4000,1,40)
:	let adj2=	RGBEl2(adjBG1A+15,							todaysec,86399,4000,1,40)
:	let adj3=	RGBEl2(adjBG2+10,							todaysec,86399,4000,1,40)
:	let hL=printf("highlight Visual guibg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+150,					todaysec,60000,8000,13000,40)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+120,					todaysec,60000,8000,13000,40)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,60000,8000,13000,40)
:	let hO=printf("highlight Type guifg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let adj1=RGBEl3(255,									todaysec,80000,0)
:	let adj2=RGBEl3(255,									todaysec,80000,255)
:	let adj3=RGBEl3(0,									todaysec,80000,0)
:	let hP=printf("highlight Cursor guibg=#%02x%02x%02x",					adj1,adj2,adj3)
:	let hP1=printf("highlight MatchParen guibg=#%02x%02x%02x",				adj1,adj2,adj3)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,44000,10000,26000,40)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,44000,10000,26000,40)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+180,					todaysec,44000,10000,26000,40)
:	let adj4=	RGBEl4(adjBG1,								todaysec,44000,10000,26000,-99,-99,-99,-99,99)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,44000,10000,26000,-99,-99,-99,-99,99)
:	let adj6=	RGBEl4(adjBG2,								todaysec,44000,10000,26000,-99,-99,-99,-99,99)
:	let hQ=printf("highlight htmlLink guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+220,					todaysec,77000,10000,26000,70)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+220,					todaysec,77000,10000,26000,70)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,77000,10000,26000,70)
:	let adj4=	RGBEl4(adjBG1,								todaysec,77000,10000,26000,-99,-99,-99,-99,99)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,77000,10000,26000,-99,-99,-99,-99,99)
:	let adj6=	RGBEl4(adjBG2,								todaysec,77000,10000,26000,-99,-99,-99,-99,99)
:	let hR=printf("highlight Question guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let hR1=printf("highlight MoreMsg guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	let adj1=	RGBEl2((-todaysec+86400)/338/2+100,					todaysec,66000,8000,8000,95)
:	let adj2=	RGBEl2((-todaysec+86400)/338/2+160,					todaysec,66000,8000,8000,95)
:	let adj3=	RGBEl2((-todaysec+86400)/338/2+0,					todaysec,66000,8000,8000,95)
:	let adj4=	RGBEl4(adjBG1,								todaysec,66000,8000,8000,-5,-5,10,3,5)
:	let adj5=	RGBEl4(adjBG1A,								todaysec,66000,8000,8000,-5,-5,10,3,5)
:	let adj6=	RGBEl4(adjBG2,								todaysec,66000,8000,8000,-5,-5,10,3,5)
:	let hS=printf("highlight Directory guifg=#%02x%02x%02x guibg=#%02x%02x%02x",		adj1,adj2,adj3,adj4,adj5,adj6)
:	if todaysec/g:changefreq!=s:oldactontime/g:changefreq || exists("g:mytime")
:		let s:oldactontime=todaysec
:		execute hA
:		execute hA1
:		execute hA2
:		execute hA3
:		execute hA4
:		execute hA5
:		execute hA6
:		execute hA7
:		execute hA8
:		execute hA9
:		execute hB
:		execute hB1
:		execute hB2
:		execute hC
:		execute hC1
:		execute hD
:		execute hE
:		execute hF
:		execute hG
:		execute hG1
:		execute hH
:		execute hI
:		execute hI1
:		execute hI2
:		execute hJ
:		execute hK
:		execute hL
:		execute hM
:		execute hN
:		execute hO
:		execute hP
:		execute hP1
:		execute hQ
:		execute hR
:		execute hR1
:		execute hS
:	endif
:	redraw
:	if exists("g:mytime") || exists("g:myhour")
:		echo "WARNING: debug is *on*"
:	endif
:endfunction       

" +------------------------------------------------------------------------------+
" | Wrapper function takes into account 'invert' global variable, used when      |
" | doing 'invert' colours behave light-dark instead of dark-light.              |
" | If you thought this effect was annoying you could you could modify this      |
" | function so it always calls muscle function with 0.                          |
" +------------------------------------------------------------------------------+
:function ExtraSetHighLight()
:	if g:highLowLightToggle==0
:		call SetHighLight(0)
:	else
:		call SetHighLight(1)
:	endif
:endfunction

au CursorHold * call ExtraSetHighLight()
au CursorHoldI * call ExtraSetHighLight()

" +------------------------------------------------------------------------------+
" | The following lines provide a invert when you go into and out of insert      |
" | mode. If you don't like this effect, just comment these two lines out!       |
" +------------------------------------------------------------------------------+
au InsertEnter * let g:highLowLightToggle=1 | call ExtraSetHighLight()
au InsertLeave * let g:highLowLightToggle=0 | call ExtraSetHighLight()

" +-----------------------------------------------------------------------------+
" | END                                                                         |
" +-----------------------------------------------------------------------------+
" | CHANGING COLOUR SCRIPT                                                      |
" +-----------------------------------------------------------------------------+

