import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WindowSwallowing
import XMonad.ManageHook


main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . xmobarProp $ myConfig

myConfig = def
   { modMask            = mod4Mask 
   , normalBorderColor  = "#dddddd"
   , focusedBorderColor = "#aa0000"
   , terminal           = "alacritty"
   , layoutHook         = smartSpacingWithEdge 5 $ myLayout
   , handleEventHook    = myHandleEventHook
   , manageHook         = myManageHook
   }
  `additionalKeysP`
    [ ("M-q",   restart "xmonad" True                 )
    , ("M-S-z", spawn "xscreensaver-command -lock"    )
    , ("M-C-p", spawn "systemctl --user stop picom"   )
    , ("M-S-p", spawn "systemctl --user start picom"  )
    , ("M-f",   sendMessage (Toggle "Full")           )
    , ("M-i",   spawn "firefox"                       ) 
    , ("M-o",   spawn "pcmanfm"                       ) 
    ]

myLayout = toggleLayouts (noBorders Full) $ smartBorders $ (tiled ||| Mirror tiled)
  where
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      
    ratio    = 1/2    
    delta    = 3/100 

myHandleEventHook = swallowEventHook (className =? "Alacritty" <||> className =? "XTerm") (return True)

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    , isFullscreen        --> doFullFloat
    ]

