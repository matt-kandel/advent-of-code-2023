# Setup
puzzle_input = read(".\\inputs\\day_01.txt", String)
function parse_input(s::String)
    hcat([collect(x) for x in split(s, "\r\n")]...) |> permutedims
end

original_grid = parse_input(puzzle_input)
grid = copy(original_grid)

# Part A
# Start from the end, and for each index check everything north
function tilt_column_north(column)
    for i in collect(eachindex(column))
        for j in i:-1:2
            if (column[j] == 'O') & (column[j-1] == '.')
                column[j], column[j-1] = column[j-1], column[j]
            end
        end
    end
end

function score(grid)
    num_Os = count(==('O'), grid, dims=2)
    return sum(num_Os .* collect(size(grid)[2]:-1:1))
end

# modifies grid, returns nothing
tilt_column_north.(eachcol(grid))
println("Part A score is $(score(grid))")

# Part B
function tilt_column_south(column)
    for i in collect(reverse(eachindex(column)))
        for j in 1:i-1
            if (column[j] == 'O') & (column[j+1] == '.')
                column[j], column[j+1] = column[j+1], column[j]
            end
        end
    end
end

# "tilt_column_north" and "tilt_column_south" are misnomers
# Maybe I should have called them "tilt_positive" and "tilt_negative"?
tilt_north(grid) = tilt_column_north.(eachcol(grid))
tilt_south(grid) = tilt_column_south.(eachcol(grid))
tilt_west(grid) = tilt_column_north.(eachrow(grid))
tilt_east(grid) = tilt_column_south.(eachrow(grid))

# Again, modifies grid, returns nothing
function spin_cycle(grid)
    tilt_north(grid)
    tilt_west(grid)
    tilt_south(grid)
    tilt_east(grid)
end

# Find a repeating sequence
grid = copy(original_grid)
grids = []
for i in 1:1_000
    spin_cycle(grid)
    if grid ∈ grids
        spin_cycle(grid)
        push!(grids, copy(grid))   
        global a # not good practice to use globals, but whatever
        global b
        a, b = findall(g -> g==grids[i], grids)
        println("Cycle starts at $a & repeats at $b")
        @assert grids[a] == grids[b] "Check algorithm, they're not equal"
        break
    end
    push!(grids, copy(grid)) 
end

# Now that we know it repeats from a to b, we can reduce the calculation
grid = copy(grids[b])
for _ in 1:mod(1e9-b-1, b-a+1)
    spin_cycle(grid)
end
println("Part B score is $(score(grid))")