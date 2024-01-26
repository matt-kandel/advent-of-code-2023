function parse_input_as_matrix(s::String)
    hcat([collect(x) for x in split(s, "\n")]...) |> permutedims
end
grid = read("inputs/day_03_test.txt", String) |> parse_input_as_matrix