open Pretty_types

(* Set foreground and background colours.
 * 
 * Available colours:
    * BLACK;
    * RED;
    * GREEN;
    * YELLOW;
    * BLUE;
    * MAGENTA;
    * CYAN;
    * WHITE
 *)
val set_fg            : colour -> unit
val set_bg            : colour -> unit

(* Reset text attributes and foreground/background colours to defaults.
 *)
val reset_attrs       : unit -> unit

(* Functions to clear areas of the screen.
 *
 * NOTE:
    * clear_to_eol -> clear to end of line
    * clear_to_sol -> clear to start of line
 *)
val clear_screen      : unit -> unit
val clear_to_eol      : unit -> unit
val clear_to_sol      : unit -> unit
val clear_line        : unit -> unit
val clear_down        : unit -> unit
val clear_up          : unit -> unit

(* Functions for scrolling the terminal; scroll_screen allows a region to be
 * set as scrollable if no argument is given then the screen is set else it
 * starts from (column, row)
 *)
val scroll_screen     : ?pos:(int * int) -> unit -> unit
val scroll_down       : unit -> unit
val scroll_up         : unit -> unit

(* Functions for cursor movement and positioning.
 *)
val move_xy           : ?x:int -> ?y:int -> unit -> unit
val move_up           : ?amount:int -> unit -> unit
val move_down         : ?amount:int -> unit -> unit
val move_forward      : ?amount:int -> unit -> unit
val move_backward     : ?amount:int -> unit-> unit
val move_save         : unit -> unit
val move_unsave       : unit -> unit
val move_save_attr    : unit -> unit
val move_restore_attr : unit -> unit

(* Print a string with given attributes - the attributes are reverted to
 * default values upon return.
 *
 * WARNING:
    * String constructor should not be used in the attribute list given to
    * this function, doing so will cause an Invalid_argument exception to be
    * raised.
 *)
val print_string_attrs : ?attrs:attribute list -> string -> unit

(* Print a list of attribute type values; strings are printed as given;
 * available constructors are:
    * Attribute -> text attribute
    * Background -> text background colour
    * Foreground -> text foreground colour
    * String -> plain string
 *)
val print_custom : attribute list -> unit

(* Print a string to the screen using a wrapper around print_string.
 * 
 * OPTIONS:
    * Supports printing text to a specific region;
    * Supports printing text with specific background/foreground colour;
    * Supports printing text with decorative attributes applied.
 *)
val print_string : ?attrs:attribute list -> ?x:int -> ?y:int -> string -> unit
