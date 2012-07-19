open Pretty_types

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
   | String s -> (* should not be used in this context *)
         raise (Invalid_argument "pp_attribute: String")

let set_fg colour =
   print_string ("\027[" ^ (pp_fg_colour colour) ^ "m")

let set_bg colour =
   print_string ("\027[" ^ (pp_bg_colour colour) ^ "m")

let reset_attrs () =
   print_string "\027[0m"

let clear_screen () =
   print_string "\027[2J\027[H"

let clear_to_eol () =
   print_string "\027[K"

let clear_to_sol () =
   print_string "\027[1K"

let clear_line () =
   print_string "\027[2K"

let clear_down () =
   print_string "\027[J"

let clear_up () =
   print_string "\027[1J"

let scroll_screen ?(pos = (-1, -1)) () =
   print_string
      (if pos = (-1, -1) then
         "\027[r"
      else
         let x = string_of_int (fst pos) and y = string_of_int (snd pos)
         in "\027[" ^ y ^ ";" ^ x ^ "r")

let scroll_down () =
   print_string "\027D"

let scroll_up () =
   print_string "\027M"

let move_xy ?(x = 0) ?(y = 0) () =
   print_string ("\027[" ^ (string_of_int y) ^ ";" ^ (string_of_int x) ^ "H")

let move_up ?(amount = 1) () =
   print_string ("\027[" ^ (string_of_int amount) ^ "A")

let move_down ?(amount = 1) () =
   print_string ("\027[" ^ (string_of_int amount) ^ "B")

let move_forward ?(amount = 1) () =
   print_string ("\027[" ^ (string_of_int amount) ^ "C")

let move_backward ?(amount = 1) () =
   print_string ("\027[" ^ (string_of_int amount) ^ "D")

let move_save () = print_string "\027[s"

let move_unsave () = print_string "\027[u"

let move_save_attr () = print_string "\0277"

let move_restore_attr () = print_string "\0278"

let print_string_attrs ?(attrs = []) str =
   let rec build_attrs = function
      | [] -> ""
      | [atr] -> (pp_attribute atr) ^ "m"
      | atr :: xs -> (pp_attribute atr) ^ ";" ^ build_attrs xs
   in
      print_string (
         (if attrs = [] then ""
         else ("\027[" ^ (build_attrs attrs))) ^ str ^ "\027[0m")

let print_custom output =
   let rec build_attrs = function
      | [] -> ""
      | [atr] -> (pp_attribute atr) ^ "m"
      | atr :: xs -> (pp_attribute atr) ^ ";" ^ build_attrs xs in
   let rec inner fmt = function
      | [] -> ""
      | x :: xs ->
            (match x with
               | Attribute _ | Foreground _ | Background _ ->
                     inner (x :: fmt) xs
               | String s ->
                     (if fmt = [] then
                        s
                     else ("\027[" ^ (build_attrs fmt) ^ s)) ^ inner [] xs)
   in
      print_string ((inner [] output) ^ "\027[0m")

let print_string ?(attrs = []) ?(x = -1) ?(y = -1) str =
   (if x <> -1 || y <> -1 then
      let x = if x <> -1 then string_of_int x else ""
      and y = if y <> -1 then string_of_int y else ""
      in print_string ("\027[" ^ y ^ ";" ^ x ^ "H"));
   
   print_string_attrs ~attrs:attrs str

let noecho_aux fd f =
   let open Unix in
   let attrs = tcgetattr stdin in
   tcsetattr fd TCSANOW { attrs with c_echo = false };
   let ret = try f fd with
      | ex -> tcsetattr fd TCSANOW attrs; raise ex
   in
   tcsetattr fd TCSANOW attrs; ret

let noecho_read_line () = noecho_aux Unix.stdin (fun fd -> read_line ())
let noecho_read_int () = noecho_aux Unix.stdin (fun fd -> read_int ())
let noecho_read_float () = noecho_aux Unix.stdin (fun fd -> read_float ())
