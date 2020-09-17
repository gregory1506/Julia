# using Pkg
# Pkg.add("DataStructures")
using DataStructures

struct Node
    parent
    f::Int64
    g::Int64
    board::Array{Int64,1}
end

function findblank(A::Array{Int64,1})
    x = size(A,1)
    for i = 1:x
        if A[i] == x
            return i
        end
    end
    return -1
end

function up(A::Array{Int64,1})
    N = size(A,1)
    Nsq = isqrt(N)
    blank = findblank(A)
    B = copy(A)
    if blank / Nsq <= 1
        return A
    end
    B[blank-Nsq],B[blank] = B[blank],B[blank-Nsq]
    return B
end

function down(A::Array{Int64,1})
    N = size(A,1)
    Nsq = isqrt(N)
    blank = findblank(A)
    B = copy(A)
    if (blank / Nsq) > (Nsq -1)
        return A
    end
    B[blank+Nsq],B[blank] = B[blank],B[blank+Nsq]
    return B
end

function left(A::Array{Int64,1})
    N = size(A,1)
    Nsq = isqrt(N)
    blank = findblank(A)
    B = copy(A)
    if (blank % Nsq) == 1
        return A
    end
    B[blank-1],B[blank] = B[blank],B[blank-1]
    return B
end

function right(A::Array{Int64,1})
    N = size(A,1)
    Nsq = isqrt(N)
    blank = findblank(A)
    B = copy(A)
    if (blank % Nsq) == 0
        return A
    end
    B[blank+1],B[blank] = B[blank],B[blank+1]
    return B
end

function manhattan(A::Array{Int64,1})
    N = size(A,1)
    Nsq = isqrt(N)
    r = 0
    for i in 1:N
        if (A[i]==i || A[i]==N)
            continue
        end
        row1 = floor((A[i]-1) / Nsq)
        col1 = (A[i]-1) % Nsq
        row2 = floor((i-1) / Nsq)
        col2 = (i-1) % Nsq
        r+= abs(row1 - row2) + abs(col1 - col2)
    end
    return r
end  

# start = [1,2,3,4,5,6,7,9,8]
# start = [6,5,4,1,7,3,9,8,2] #26 moves
# start = [7,8,4,11,12,14,10,15,16,5,3,13,2,1,9,6] # 50 moves
# start = [7,14,16,9,10,2,11,13,6,15,4,12,5,1,8,3] # 54 moves
start = [15,14,1,6,9,11,4,12,16,10,7,3,13,8,5,2] # 52 moves
goal = [x for x in 1:length(start)]
# println("The manhattan distance of $start is  $(manhattan(start))")
g = 0
f = g + manhattan(start)
pq = PriorityQueue()
actions = [up,down,left,right]
dd = Dict{Array{Int64,1},Int64}()
snode = Node(C_NULL,f,g,start)
enqueue!(pq,snode,f)
pos_seen = 0
moves = 0
while (!isempty(pq))
    current = dequeue!(pq)
    if haskey(dd,current.board)
        continue
    else
        push!(dd, current.board =>current.f)
    end
    if (current.board == goal)
        while(current.board != start)
            h = current.f - current.g
            println("$(current.board) $(current.f) $h")
            global moves +=1
            current = current.parent[]
        end
        println(start)
        println("$start solved in $moves moves after looking at $pos_seen positions")
        break
    end
    global pos_seen+=1
    for i in 1:4
        if (i == 1)
            nextmove = up(current.board)
        elseif (i == 2)
            nextmove = down(current.board)
        elseif (i == 3)
            nextmove = left(current.board)
        else
            nextmove = right(current.board)
        end
        # if (nextmove === nothing || nextmove == current.board || haskey(dd,nextmove))
        if (nextmove == current.board || haskey(dd,nextmove))
            # println("I continued $pos_seen")
            continue
        else
            newg = current.g + 1
            newf = newg + manhattan(nextmove)
            n = Node(Ref(current),newf,newg,nextmove)
            enqueue!(pq,n,newf)
        end
    end
end
println("END")
