type attr =
   | RESET
   | BRIGHT
   | DIM
   | UNDERSCORE
   | BLINK
   | REVERSE
   | HIDDEN

type colour =
   | BLACK
   | RED
   | GREEN
   | YELLOW
   | BLUE
   | MAGENTA
   | CYAN
   | WHITE

type attribute =
   | Attribute of attr
   | Foreground of colour
   | Background of colour
   | String of string
