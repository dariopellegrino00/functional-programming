module Graph = 
  struct 
    type vertex = Vertex of int
    type edge = Edge of int * vertex * vertex
    type graph = {mutable vertices: vertex list; mutable edges: edge list}

    let empty () = {vertices = []; edges = []}

    let add_vertex g v = g.vertices <- v :: g.vertices
      
    let add_edge g e = g.edges <- e :: g.edges

    let remove_vertex g v = 
      let f acc x = if (x = v) then acc else x :: acc in 
      g.vertices <- List.fold_left f [] g.vertices

    let remove_edge g x y = 
      let f e = match e with 
                | Edge (_, v1, v2) when (x = v1 && y = v2) -> true
                | _ -> false in 
      g.edges <- List.filter f g.edges

    let adjacent g x y = 
      let f e = match e with 
                | Edge (_, v1, v2) when (x = v1 && y = v2 || y = v2 && x = v1) -> true
                | _ -> false in  
      List.exists f g.edges
    
    let neighbors g x = 
      let f acc e = match e with 
                | Edge (_, v1, v2) when x = v1 -> v2 :: acc
                | _ -> acc in 
      List.fold_left f [] g.edges          
    
    let get_vertex_value g v =
      match List.find (fun x -> x = v) g.vertices with Vertex v -> v
     
    let set_vertex_value g v value =
      let rec f vs = 
        match vs with
        |[] -> vs 
        |v' :: vs' -> match v' with
                      |Vertex vt when v' = v -> (Vertex value) :: vs' 
                      | _                    -> f vs' in     
        g.vertices <- f g.vertices

    let get_edge_value g x y = 
      let f e = match e with Edge (v, x', y') -> if (x = x' && y = y') 
        then true else false in
      match List.find f g.edges with Edge (v, _ , _) -> v
    
    let set_edge_value g x y v =
      let rec f es = 
        match es with
        |[] -> es 
        |e' :: es' -> match e' with
                      |Edge (_ , x', y') when (x = x' && y = y') -> (Edge (v, x, y)) :: es' 
                      | _                    -> f es' in     
        g.edges <- f g.edges
                
  end;;


  module Main =
    struct
      let graph = Graph.empty();; 

      Graph.add_vertex graph (Vertex 0);;
      Graph.add_vertex graph (Vertex 1);; 
      Graph.add_vertex graph (Vertex 2);;
      
      Graph.add_edge graph (Edge (2, (Vertex 0), (Vertex 1)));;
      Graph.add_edge graph (Edge (1, (Vertex 0), (Vertex 2)));;
      Graph.add_edge graph (Edge (1, (Vertex 2), (Vertex 0)));;
      Graph.add_edge graph (Edge (3, (Vertex 1), (Vertex 2)));;

  end;;