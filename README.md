# zBar
zBar is an ActionBar addon for World of Warcraft, which allows you modify layout of action bars easily.

# Usage #

## Basics ##

  * Move bar by dragging the tab, which is on top of the first button of every bar
  * Left Click on tab will minimize bar, Right Click will summon the Option Window
  * A console command "/zbar" will open the option window if you can't find any tab.

# Features #

## Auto Pop & Auto Hide ##

  * AutoPop: Bar with this feature enabled will only be shown while inCombat or targeting on enemy
  * AutoHide: Hide while inCombat or targeting on enemy
  * U can put two bar at same place, one AutoPop, another AutoHide, then it'll work just like auto swich page.

## Auto Page ##

  * Hold alt key or has assitable target, the MainBar will switch to page 2.
  * U could put healing spells or heal stone, potions, bandage into page 2

## Simple Stick Sticky ##

  * Drag tab into any button, hold modifier keys at the same time
  * Ctrl: Stick to Bottom of target button
  * Shift: Stick to Right of target button

## Transparency and Minimize ##

  * Drag "Alpha" slider will transparentize bar, recover when getting mouse focus
  * Left click on tab will minimize bar, this state will not be saved

## Layouts - Multi-Line and Special ##

  * Set num of buttons per line will queue buttons as multi line
  * Click radio buttons of "Layout" will get an special layout
    1. Suite1: Predefined layout suite for variational num of buttons. Classic shapes.
    1. Suite2: Another suite. Fancy shapes.
    1. Circle: Ringed around. Set the "Button Spacing" slider to change radius.
    1. Free: Move a button by hold Ctrl+Alt+Shift and drag it. Scale it by Mouse Wheel.
    1. Invert: Mirror the layout Horizontally, left to right, right to left.

## Extra bar and Shadow bar ##

  * Two Extra Bar, 24 Buttons, the page will choose by your class
  * Shadow bar use the buttons that Extra bar thrown
  * e.g. ExtraBar1 set button num to 7, then ShadowBar1 get 5 button
  * To know how this gonna work, try change the num of buttons

## Lite Mode and Customize ##

  * Enable the mod "zBar2Lite" will make zBar2 into Lite Mode
  * Lite Mode only have extra bar and shadow bar, No Changes to Default UI
  * You can Customize which plugin to be load, please read the readme file

## Mini XP bar ##

  * A half size XP bar, movable, scaleable. Has all the feature of the original one
  * The width can be changed by adjust "Num of Buttons"

## Simple Cast bar ##

  * Simply replaced texture and makes spell icon show on left. movable, scaleable
  * Change "Num of Buttons" to hide the spell icon
  * Set "Invert" to make spell icon show on the other side.
