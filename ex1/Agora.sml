  
(*
    OS.Process.exit(OS.Process.success); //Exit sml
*)

(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
(* Reads first line which has number n. The second line has n values and everything returns with a tuple *)


fun parse file =
    let
        (* A function to read an integer from specified input. *)
        fun readInt input = 
        IntInf.fromInt(Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input))

        (* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
        val n = readInt inStream
        val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
        fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
        | readInts i acc = readInts (i - 1) (readInt inStream:: acc)
    in
        (n, readInts n [])
    end;
    
fun lcm (x,y) = 
    let
    (* The code for the calculation of gcd was found here: https://rosettacode.org/wiki/Greatest_common_divisor#Standard_ML *)
        fun gcd a 0 = a
        | gcd a b = gcd b (a mod b)
            
        val g = IntInf.toLarge(gcd x y)
    in
        IntInf.toLarge(x*(y div g))
    end

fun lcmOfLR ([],_,_,_,_) = print "nothing read\n"
    | lcmOfLR (left,right,_,_,0) = lcmOfLR (left,(tl right),(hd right),0,1)    
    | lcmOfLR (left,[r],acc,i,count) = 
        let	
            val templcm = hd left
        in
            if ((templcm < r) andalso (templcm < acc)) 
                then (print (IntInf.toString (templcm));print " ";print (IntInf.toString count);print "\n")
            else (print (IntInf.toString acc);print " ";print (IntInf.toString i);print "\n")
        end
    | lcmOfLR (left,right,acc,vilNo,count) = 
        let	
            val templcm = lcm(hd left,hd (tl right))
        in
            if (templcm < acc) then (lcmOfLR ((tl left),(tl right),templcm,(count+1),(count+1)))
            else (lcmOfLR ((tl left),(tl right),acc,vilNo,(count+1)))
        end
    
fun agora fileName = 
    let	
        val input = parse fileName
        (* This function calculates the lcm of the input list from right to left *)
        fun FromRight ([],acc) = acc
        |	FromRight ([a],acc) = lcm(hd acc,a)::acc (* Everytime we calculate an lcm we put it at the head of the list/acc-->this way we have right to left *) 
        |   FromRight (listX,acc) =
                if (null acc) then FromRight (tl listX,hd listX::acc)
                else	FromRight (tl listX,lcm(hd listX,hd acc)::acc)
        (* This function calculates the lcm of the input list from left to right *)	
        fun FromLeft listX = FromRight (List.rev listX,[]);
                
    in
        lcmOfLR ((List.rev (FromLeft (#2 input))),(FromRight (#2 input,[])),0,0,0)
    end        