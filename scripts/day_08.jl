# Setup
lines = readlines("inputs/day_08.txt")

struct Node
    start::String
    left::String
    right::String
end

function parse(lines::Vector{String})
    instructions = collect(lines[1])
    nodes = [Node(line[1:3], line[8:10], line[13:15]) for line ∈ lines[3:end]]
    return instructions, nodes
end

instructions, nodes = parse(lines)

# Part A
function next_node(nodes::Vector{Node}, start::String, which::Char)
    node = filter((n -> n.start == start), nodes)[1]
    return which == 'L' ? node.left : node.right
end

function solve_part_a(nodes::Vector{Node}, instructions::Vector{Char})
    n = 0
    len = length(instructions)
    node = "AAA"
    
    while node != "ZZZ"
        i = mod(n+1, len) > 0 ? mod(n+1, len) : len 
        which = instructions[i]
        node = next_node(nodes, node, which)
        n += 1
    end

    return n
end

println("Part A answer: $(solve_part_a(nodes, instructions))")

# Part B
import Base.endswith
endswith(node::Node, char::Char) = endswith(node.start, char)
next_node(nodes::Vector{Node}, node::Node, which::Char) = next_node(nodes, node.start, which)

function solve_node(nodes::Vector{Node}, start_node::Node, instructions::Vector{Char})
    # Assuming that every A-node has exactly one corresponding Z-node
    n = 0
    len = length(instructions)
    z_nodes = []
    current_node = start_node
    
    while !endswith(current_node, 'Z')
        i = mod(n+1, len) > 0 ? mod(n+1, len) : len 
        which = instructions[i]
        current_node = next_node(nodes, current_node, which)    
        n += 1
        if endswith(current_node, 'Z')
            push!(z_nodes, current_node)
        end
    end

    return n
end

prime_factors(n::Int) = [i for i ∈ 2:(n-1) if mod(n, i) == 0]

a_nodes = nodes[endswith.(nodes, 'A')]
steps_per_node = [solve_node(nodes, node, instructions) for node ∈ a_nodes]
unique_primes = Set()
for step ∈ steps_per_node
    for factor ∈ prime_factors(step)
       push!(unique_primes, factor)
    end
end

println("Part B answer: $(prod(unique_primes))")