import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import XMonad.Hooks.EwmhDesktops


myConfig = def
   { modMask    = mod4Mask 
   , layoutHook = myLayout
   , terminal   = "alacritty"
   }
  `additionalKeysP`
    [ ("M-q", restart "xmonad" True                   )
    , ("M-S-z", spawn "xscreensaver-command -lock"    )
    , ("M-C-p", spawn "systemctl --user stop picom"   )
    , ("M-S-p", spawn "systemctl --user start picom"  )
    , ("M-b",   spawn "firefox"                       ) 
    ]

myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      
    ratio    = 1/2    
    delta    = 3/100 

main = xmonad $ ewmhFullscreen $ ewmh $ myConfig
