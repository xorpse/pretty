open Pretty_types

let esc () = "\027"

let resolve_opt = function
   | None -> ""
   | Some n -> string_of_int n

let pp_fg_colour = function
   | BLACK -> "30"
   | RED -> "31"
   | GREEN -> "32"
   | YELLOW -> "33"
   | BLUE -> "34"
   | MAGENTA -> "35"
   | CYAN -> "36"
   | WHITE -> "37"

let pp_bg_colour = function
   | BLACK -> "40"
   | RED -> "41"
   | GREEN -> "42"
   | YELLOW -> "43"
   | BLUE -> "44"
   | MAGENTA -> "45"
   | CYAN -> "46"
   | WHITE -> "47"

let pp_attr = function
   | RESET -> "0"
   | BRIGHT -> "1"
   | DIM -> "2"
   | UNDERSCORE -> "3"
   | BLINK -> "4"
   | REVERSE -> "5"
   | HIDDEN -> "6"

let pp_attribute = function
   | Attribute attr -> pp_attr attr
   | Foreground colour -> pp_fg_colour colour
   | Background colour -> pp_bg_colour colour
   | String s -> s

let pp_erase = function
   | Erase_EOL -> "K"
   | Erase_SOL -> "1K"
   | Erase_line -> "2K"
   | Erase_down -> "J"
   | Erase_up -> "1J"
   | Erase_screen -> "2J"
   
let pp_scroll = function
   | Scroll_screen (st, en) ->
         (match st, en with
            | None, None -> ""
            | _ -> (resolve_opt st) ^ ";" ^ (resolve_opt en)) ^ "r"
   | Scroll_down -> "D"
   | Scroll_up -> "M"

let pp_movement = function
   | Move_home (row, col) ->
         (match row, col with
            | None, None -> ""
            | _ -> (resolve_opt row) ^ ";" ^ (resolve_opt col)) ^ "H"
   | Move_up n -> (resolve_opt n) ^ "A"
   | Move_down n -> (resolve_opt n) ^ "B"
   | Move_forward n -> (resolve_opt n) ^ "C"
   | Move_backward n -> (resolve_opt n) ^ "D"
   | Move_save -> "s"
   | Move_unsave -> "u"
   | Move_save_attrs -> "7"
   | Move_restore_attrs -> "8"

let pp_escape = function
   | Attributes al -> (esc ()) ^ "[" ^ (List.fold_right (fun at nx -> (pp_attribute at) ^ (if nx <> "m" then ";" else "") ^ nx) al "m")
   | Movement m -> (esc ()) ^ "[" ^ (pp_movement m)
   | Scroll s -> (esc ()) ^ "[" ^ (pp_scroll s)
   | Erase e -> (esc ()) ^ "[" ^ (pp_erase e)

let set_fg colour = print_string ((esc ()) ^ "[" ^ (pp_fg_colour colour) ^ "m")
let set_bg colour = print_string ((esc ()) ^ "[" ^ (pp_bg_colour colour) ^ "m")
let reset_attrs () = print_string "\027[0m"
let clear_screen () = print_string "\027[2J\027[H"
let goto_xy x y = print_string ("\027[" ^ (string_of_int y) ^ ";" ^ (string_of_int x) ^ "H")

let print_string_attrs ?(attrs = []) str =
   let rec build_attrs = function
      | [] -> ""
      | [atr] -> (pp_attribute atr) ^ "m"
      | atr :: xs -> (pp_attribute atr) ^ ";" ^ build_attrs xs
   in print_string ((if attrs = [] then "" else ("\027[" ^ (build_attrs attrs))) ^ str ^ "\027[0m")

let print_custom output =
   let rec build_attrs = function
      | [] -> ""
      | [atr] -> (pp_attribute atr) ^ "m"
      | atr :: xs -> (pp_attribute atr) ^ ";" ^ build_attrs xs in
   let rec inner fmt = function
      | [] -> ""
      | x :: xs ->
            (match x with
               | Attribute _ | Foreground _ | Background _ -> inner (x :: fmt) xs
               | String s ->
                     (if fmt = [] then s else ("\027[" ^ (build_attrs fmt) ^ s)) ^ inner [] xs)
   in
      print_string ((inner [] output) ^ "\027[0m")

let print_string ?(attrs = []) ?(x = -1) ?(y = -1) str =
   if x <> -1 || y <> -1 then print_string ("\027[" ^ (string_of_int y) ^ ";" ^ (string_of_int x) ^ "H");
   print_string_attrs ~attrs:attrs str
