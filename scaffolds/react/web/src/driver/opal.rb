require 'opal'
require 'gamefic'
require 'main'

$plot = Gamefic::Plot.new
$character = $plot.make_player_character
$plot.introduce $character
