module type Graph =
    sig 
        type edge
        type vertex
        type graph

        val empty : graph
        val add_vertex : graph -> vertex -> unit
        val add_edge : graph -> edge -> unit

        val remove_vertex : graph -> vertex -> unit
        val remove_edge : graph -> vertex -> vertex -> unit

        val adjacent : graph -> vertex -> vertex -> bool
        val neighbors : graph -> vertex -> vertex list

        val get_vertex_value : graph -> vertex -> int
        val set_vertex_value : graph -> vertex -> int -> unit

        val get_edge_value : graph -> vertex -> vertex -> int
        val set_edge_value : graph -> vertex -> vertex -> int -> unit
        
    end;;