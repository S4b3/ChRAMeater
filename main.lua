local composer = require( "composer" )
 
-- Nascondi la barra di stato
display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )
 
-- Generazione numero random
math.randomseed( os.time() )

-- Inizializza audio
audio.reserveChannels( 2 )
audio.setVolume( 0.8, { channel=2 } )
audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )
 
-- Vai al menu
composer.gotoScene( "menu" )