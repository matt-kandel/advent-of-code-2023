# Setup
function parse_input_as_matrix(s::String)
    hcat([collect(x) for x in split(s, "\n")]...) |> permutedims
end
grid = read("inputs/day_03.txt", String) |> parse_input_as_matrix

# Part A
function is_adjacent_to_symbol(i, j, grid)
    # for my purposes, a value is adjacent to itself
    m, n = size(grid)
    eyes = (maximum([i-1, 1])):(minimum([i+1, m]))
    jays = (maximum([j-1, 1])):(minimum([j+1, n]))
    is_adjacent = (x -> !isnumeric(x) && x != '.').(grid[eyes, jays])
    return any(is_adjacent)
end

struct Cell
    char::Char
    is_adjacent_to_symbol::Bool
end

function read_grid_as_matrix_of_cells(grid::Matrix{Char})
    m, n = size(grid)
    Cells = Matrix{Union{Missing, Cell}}(missing, m, n)
    for i in 1:m
        for j in 1:n
            Cells[i, j] = Cell(grid[i, j], is_adjacent_to_symbol(i, j, grid))
        end
    end
    return Cells
end

function read_valid_numbers(grid)
    cells = read_grid_as_matrix_of_cells(grid)
    m, n = size(cells)
    valid_numbers::Vector{Int} = []
    is_valid::Bool = false
    number = ""
    for i in 1:m
        for j in 1:n
            cell = cells[i, j]
            char = cell.char
            if isnumeric(char)
                is_valid = is_valid || cell.is_adjacent_to_symbol
                number *= char
            end
            if !isnumeric(char) || j == n
                if is_valid && number != ""
                    push!(valid_numbers, parse(Int, number))
                end
                number = ""
            is_valid = false
            end
        end
    end
    return valid_numbers
end
println("Part A answer: $(sum(read_valid_numbers(grid)))")

# Part B
# Not going to do this right now, but just sketching out some thoughts
# It seems easier to collect the numbers rather than the stars
# so make some kind of loop that will iterate through the grid
# As you go, increment the number similar to above with number *= char
# and you can keep appending coordinates to star_neighbors
# then, once you have all the PartNumbers, invert it somehow
# so that we have a dict of {star_neighbors: PartNumbers::Vector{Int}}
# then, the rest of the problem is easy
mutable struct PartNumber
    number::Int # This will grow like above with *= operator
    star_neighbors::Set{Tuple{Int}} # a set of unique coordinate pairs (i, j)
end