type uchar = int

type t = (int * int) list

let max_code = max_int - 1  (* must be < max_int *)
let min_code = -1

let empty = []
let singleton i = [i,i]
let is_empty = function [] -> true | _ -> false
let interval i j = if i <= j then [i,j] else [j,i]
let eof = singleton (-1)
let any = interval 0 max_code

let print ppf l =
  Format.fprintf ppf "[ ";
  List.iter (fun (i,j) -> Format.fprintf ppf "%i-%i " i j) l;
  Format.fprintf ppf "]"

let dump l =
  print Format.std_formatter l

let rec union c1 c2 =
  match c1,c2 with
    | [], _ -> c2
    | _, [] -> c1
    | ((i1,j1) as s1)::r1, ((i2,j2) as s2)::r2 ->
	if (i1 <= i2) then
	  if j1 + 1 < i2 then s1::(union r1 c2)
	  else if (j1 < j2) then union r1 ((i1,j2)::r2)
	  else union c1 r2
	else union c2 c1

let complement c =
  let rec aux start = function
    | [] -> if start <= max_code then [start,max_code] else []
    | (i,j)::l -> (start,i-1)::(aux (succ j) l) in
  match c with
    | (-1,j)::l -> aux (succ j) l
    | l -> aux (-1) l

let intersection c1 c2 = 
  complement (union (complement c1) (complement c2))


let difference c1 c2 =
  complement (union (complement c1) c2)
  
