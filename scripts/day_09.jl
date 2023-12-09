# Setup
parse_line(line::String) = parse.(Int, split(line, " "))
sequences = parse_line.(readlines("inputs/day_09.txt"))

# Part A
function find_differences(sequence::Vector{Int})
    differences = []
    next_differences = diff(sequence)
    while any(next_differences .!= 0)
        push!(differences, next_differences)
        next_differences = diff(next_differences)
    end
    return differences
end

function extrapolate(sequence::Vector{Int})
    differences = find_differences(sequence)
    ◤ = pushfirst!(differences, sequence)
    val = 0
    for i in length(◤):-1:1
        val += ◤[i][end]
    end
    return val
end

println("Part A answer: $(extrapolate.(sequences) |> sum)")

# Part B
function extrapolate_backwards(sequence::Vector{Int})
    differences = find_differences(sequence)
    ◤ = pushfirst!(differences, sequence)
    val = 0
    for i in length(◤):-1:1
        val = ◤[i][1] - val
    end
    return val
end

println("Part B answer: $(extrapolate_backwards.(sequences) |> sum)")