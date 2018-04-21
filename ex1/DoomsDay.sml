
type Point = int * int
type Node = int * int * char * int
structure Point : ORD_KEY =
    struct
        type ord_key =  Point
        val compare = fn (x: ord_key, y: ord_key) =>
            if (#1 x = #1 y) andalso (#2 x = #2 y) then
                EQUAL
            else if (#1 x > #1 y) orelse (#1 x = #1 y) andalso (#2 x > #2 y) then
                GREATER
            else
                LESS
    end
structure Map = BinaryMapFn(Point)
val q: Node Queue.queue = Queue.mkQueue()
fun parse file =
    let
        fun parseLine line i map =
            let
                val chars = explode line
                fun aux [] j map = (j,map)
                |   aux (h::t) j map =
                let
                    val _ = if (h= #"+") orelse (h= #"-") then Queue.enqueue (q,(i,j,h,0))
                            else ()
                    val newmap = Map.insert(map,(i,j),h)
                in
                    aux t (j+1) newmap
                end
            in
                aux chars 0 map
            end
        val ins = TextIO.openIn file
        fun getLines ins =
            case TextIO.inputLine ins of
                SOME line => line :: getLines ins
                | NONE      => []
        val lines = List.filter (fn x => not (x="" orelse x="\n")) (getLines ins)
        val rows = length lines
        fun parseLines [] _  map = (0,map)
        |   parseLines [l] i map = parseLine l i map
        |   parseLines (h::t) i map =
            let
                val (_,newmap) = parseLine h i map
            in
                parseLines t (i+1) newmap
            end
        val map: char Map.map = Map.empty
        val (columns, map) = parseLines lines 0 map
    in
        (rows, columns, map)
    end
fun findNeighbors (node : Node, map: char Map.map) =
    let
        fun isValid (point : Point) =
            case Map.find(map, point) of
                SOME c => c = #"." orelse ((c = #"+" orelse c = #"-") andalso not (c = #3 node))
                | NONE => false
        val (i, j, _, t) = node
        fun getNeighbor (x: int, y: int): Node =
            (x,y,Option.valOf(Map.find(map,(x,y))),t+1)
        val neighborPositions = [(i+1,j),(i-1,j),(i,j+1),(i,j-1)]
    in
        List.map (getNeighbor) (List.filter (isValid) neighborPositions)
    end
fun printGrid (rows, columns, map) =
    let
        val map = Map.map (Char.toString) map
        fun printRow row =
            let
                fun aux row column =
                    let
                        val _ = print (#2 (Map.remove(map,(row,column))))
                    in
                        if (column < columns-2) then aux row (column+1) else ()
                    end
            in
                aux row 0
            end
        fun aux row =
            let
                val _ = printRow row
                val _ = print "\n"
            in
                if (row < rows-1) then aux (row+1) else ()
            end
    in
        aux 0
    end
fun solve (rows, columns, map) =
    let
        fun finish (isCollided, collisionTime, map) =
            let
                val msg = if isCollided then (Int.toString (collisionTime))^"\n" else "the world is saved\n"
                val _ = print msg
            in
                map
            end
        fun clearQueue state =
            let
                val _ = Queue.clear(q)
            in
                state
            end
        fun addNeighbors node (isCollided,collisionTime,map) =
            let
                fun aux [] _ state = state
                |   aux (h::t) node (isCollided,collisionTime,map) =
                    let
                        val (nx,ny,nc,nt) = h
                        val (cx,cy,cc,_) = node
                        val newc = if (nc = #".") then cc else #"*"
                        val _ = if (nc = #".") then Queue.enqueue(q,(nx,ny,newc,nt)) else ()
                        val newstate = if (newc = #"*") then (true, nt, Map.insert(map, (nx,ny), newc))
                                                    else (isCollided, collisionTime, Map.insert(map, (nx,ny), newc))
                    in
                        aux t node newstate
                    end
            in
                aux (findNeighbors(node,map)) node (isCollided,collisionTime,map)
            end
        fun aux (isCollided, collisionTime, map) =
            let
                val (x,y,c,t) = Queue.dequeue(q)
            in
                if isCollided andalso (t+1 > collisionTime) then clearQueue(isCollided, collisionTime, map)
                else addNeighbors (x,y,c,t) (isCollided, collisionTime, map)
            end
        fun loop state =
            if Queue.isEmpty(q) then finish state
            else loop (aux state)
    in
        printGrid (rows, columns, loop (false, 0, map))
    end
fun doomsday fileName = solve (parse fileName)