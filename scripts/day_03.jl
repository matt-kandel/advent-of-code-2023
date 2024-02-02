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
mutable struct Part
    number::String # This will grow like above with *= operator
    star_neighbors::Set # a set of unique coordinate pairs (i, j)
end

function find_star_neighbors(i, j, grid)
    # for my purposes, a value is adjacent to itself
    m, n = size(grid)
    eyes = (maximum([i-1, 1])):(minimum([i+1, m]))
    jays = (maximum([j-1, 1])):(minimum([j+1, n]))
    star_coordinates::Set = Set()
    for i in eyes
        for j in jays
            if grid[i, j] == '*'
                push!(star_coordinates, (i, j))
            end
        end
    end
    return star_coordinates
end

function create_parts(grid)
    parts::Vector{Part} = []
    m, n = size(grid)
    part = Part("", Set())
    star_neighbors::Set = Set()
    for i in 1:m
        for j in 1:n
            char = grid[i, j]
            if isnumeric(char)
               part.number *= char
               part.star_neighbors = union(part.star_neighbors, find_star_neighbors(i, j, grid))
            end
            if !isnumeric(char) || j == n
                if part.number != ""
                    push!(parts, part)
                end
                part = Part("", Set())
                star_neighbors = Set()
            end
        end
    end
    return parts
end
parts = create_parts(grid)

# we can ignore the empty ones
parts = filter(x -> !isempty(x.star_neighbors), parts)

# Flip it so that we're looking up Parts by star
# instead of stars by Parts
# for stars Dict: keys are * coordinates as tuple (i, j)
# values are vector of all the (not unique) parts
# that have this star as a neighbor
stars = Dict()
for part in parts
    for coordinate in part.star_neighbors
        if haskey(stars, coordinate)
            stars[coordinate] = vcat(stars[coordinate], parse(Int, part.number))
        else
            stars[coordinate] = [parse(Int, part.number)]
        end
    end
end

# vector of vector of Ints
part_values = values(stars) |> collect
function score(part_values)
    points = 0
    for vector ∈ part_values
        if length(vector) == 2
            points += vector[1] * vector[2]
        end
    end
    return points
end
println("Part B answer: $(score(part_values))")