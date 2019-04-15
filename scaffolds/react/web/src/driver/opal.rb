require 'opal'
require 'gamefic'
require 'main'

$plot = Gamefic::Plot.new
$character = $plot.get_player_character
$plot.introduce $character
