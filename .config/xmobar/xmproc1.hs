Config { font     = "xft:iosevka-11"
       , bgColor  = "black"
       , fgColor  = "#f8f8f2"
       , position = Top
       , commands = [ Run Weather "EGPF"
                        [ "--template", "<weather> <tempC>°C"
                        , "-L", "0"
                        , "-H", "25"
                        , "--low"   , "#61AEEF"
                        , "--normal", "#f8f8f2"
                        , "--high"  , "#F07178"
                        ] 36000
                    , Run Network "wlp0s20f3" 
                        [ "--template" , "Ͳ <tx>↑ <rx>↓" 
                        , "-L", "1"
                        , "-H", "100"
                        , "--high"  , "#F07178"
                        , "--normal", "#98C379"
                        , "--low"   , "#61AEEF"
                        ] 10
                    , Run Battery 
                        [ "-t", "<left>% <acstatus>"
                        , "-L", "30"
                        , "-H", "70"
                        , "--low"  , "#F07178"
                        , "--normal", "#98C379"
                        , "--high"   , "#61AEEF"
                        , "--"
                        , "-i", "▒"
                        , "-O", "⚡"
                        , "-o", "▒"
                        , "-h", "#98C379"
                        , "-l", "#F07178"
                        ] 100
                    , Run Cpu
                        [ "-t", "◍ <total>%"
                        , "-L", "3"
                        , "-H", "50"
                        , "--high"  , "#F07178"
                        , "--normal", "#98C379"
                        , "--low"   , "#61AEEF"
                        ] 10
                    , Run Alsa "default" "Master"
                        [ "--template", "<volumestatus>"
                        , "--suffix"  , "True"
                        , "-L", "30"
                        , "-H", "80"
                        , "--high"  , "#F07178"
                        , "--normal", "#98C379"
                        , "--low"   , "#61AEEF"
                        , "--"
                        , "--on", ""
                        ] 
                    , Run Memory [ "--template", "ⵂⵂⵂⵂ <usedratio>%"
                        , "-L", "30"
                        , "-H", "80"
                        , "--high"  , "#F07178"
                        , "--normal", "#98C379"
                        ] 10
                    , Run Date "%a %d %b %H:%M" "date" 10
                    , Run UnsafeStdinReader
                    -- , Run XMonadLog
                    -- , Run Brightness ["-t", "☼"] 60
                    ]
       , sepChar  = "%"
       , alignSep = "}{"
       , template = " %UnsafeStdinReader% }{  %wlp0s20f3% | Ə %alsa:default:Master% | %cpu% | %memory% | %date% | %battery% "
       }
