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
    symbol::Char
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
    is_valid_number::Bool = false
    number = ""
    for i in 1:m
        for j in 1:n
            cell = cells[i, j]
            symbol, is_valid_number = cell.symbol, is_valid_number || cell.is_adjacent_to_symbol
            if isnumeric(symbol)
                number *= symbol
            end
            if !isnumeric(symbol) || j == n
                if is_valid_number && number != ""
                    push!(valid_numbers, parse(Int, number))
                end
                number = ""
                is_valid_number = false
            end
        end
    end
    return valid_numbers
end
#1301068 and 544825 are both too high
print("Part A answer: $(sum(read_valid_numbers(grid)))")