type movement =
   | Move_home of int option * int option
   | Move_up of int option
   | Move_down of int option
   | Move_forward of int option
   | Move_backward of int option
   | Move_save
   | Move_unsave
   | Move_save_attrs
   | Move_restore_attrs

type scroll =
   | Scroll_screen of int option * int option
   | Scroll_down
   | Scroll_up

type erase =
   | Erase_EOL
   | Erase_SOL
   | Erase_line
   | Erase_down
   | Erase_up
   | Erase_screen

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

type escape =
   | Attributes of attribute list
   | Movement of movement
   | Scroll of scroll
   | Erase of erase
