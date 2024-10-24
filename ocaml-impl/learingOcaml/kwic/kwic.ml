
type kwic_line = {line_idx: int; keyword: string; keyword_idx: int}

type kwic_index = {original_lines : string list; index_lines : kwic_line list}

let is_minor_word word = let w = String.uncapitalize_ascii word in String.length w < 3 || w = "the" || w = "and"

let kwic_compare l1 l2 = String.compare l1.keyword l2.keyword

let read_file_lines file = 
  try 
    let lines = In_channel.open_text file |> In_channel.input_lines in
    List.filter (fun x -> x <> "" ) (List.map (fun x -> String.trim x) lines)
  with e -> Printf.printf "%s %s %s\n" "failed to open file" file (Printexc.to_string e); [] 

let rec split_list i ?(acc = []) list = 
  match list with 
    hd :: tl when i > 0 -> split_list (i-1) ~acc: (hd :: acc) tl
  | hd :: tl when i = 0 -> (List.rev acc, tl) 
  | _                   -> (List.rev acc, list)

let rec insert_sorted comp e ?(acc  = [])  = function (** redo with fun*)
  | hd :: tl -> 
    if comp hd e > 0 then List.rev_append (hd :: e :: acc) tl else insert_sorted comp e ~acc: (hd :: acc) tl
  | _        -> List.rev (e :: acc)


let get_kwic_index text_file = 
  let titles = read_file_lines text_file in 
  let index_kwic = ref [] in 
  List.iteri ( fun i title -> 
    let splitted = String.split_on_char ' ' title in 
    List.iteri (fun j word -> 
      if not (is_minor_word word) then 
      index_kwic := insert_sorted kwic_compare {line_idx = i; keyword = word; keyword_idx = j} !index_kwic
    ) splitted
  ) titles;
  {original_lines = titles; index_lines = !index_kwic}

let print_kwic_index kwic_index = 
  List.iter ( fun line -> 
      let pre_words, post_words = 
        split_list line.keyword_idx (String.split_on_char ' ' (List.nth kwic_index.original_lines line.line_idx)) in 
      let pre = List.fold_left (fun x acc -> x ^ " " ^ acc) "" pre_words |> String.trim in
      let post = List.fold_left (fun x acc ->  x ^ " " ^ acc) "" post_words |> String.trim in

      let pre_trunc = if String.length pre > 33 then String.sub pre (String.length pre - 33) 33 else pre in 
      let keyword_trunc = if String.length line.keyword > 40 then String.sub line.keyword 0 40 else line.keyword in 
      let post_trunc = if String.length post + String.length keyword_trunc > 40 
        then String.sub post 0 (40 - String.length keyword_trunc) else post in 

      Printf.printf "%5d %33s %s %s\n" (line.line_idx mod 10000) pre_trunc keyword_trunc post_trunc
    ) kwic_index.index_lines

let print_kwic_from_file file_name =  
    let kwic_index = get_kwic_index file_name in 
    print_kwic_index kwic_index