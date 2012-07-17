open Pretty_types

val set_fg       : colour -> unit
val set_bg       : colour -> unit

val reset_attrs  : unit -> unit
val clear_screen : unit -> unit

val goto_xy      : int -> int -> unit

val print_string_attrs : ?attrs:attribute list -> string -> unit
val print_custom : attribute list -> unit

val print_string : ?attrs:attribute list -> ?x:int -> ?y:int -> string -> unit
