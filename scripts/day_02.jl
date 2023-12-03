games = readlines("inputs/day_02.txt")

# Day Two, Part A
struct Game
    ID::Int
    reds::Int
    greens::Int
    blues::Int
end

function decode(line::String)
    """
    Parse each line of code as a game with an ID and the maximum number of each color
    """
    ID = parse(Int, split(match(r"Game \d+", line).match, " ")[end])
    reds = [parse.(Int, split(x.match, " ")[1]) for x in eachmatch(r"\d+ red", line)]
    greens = [parse.(Int, split(x.match, " ")[1]) for x in eachmatch(r"\d+ green", line)]
    blues = [parse.(Int, split(x.match, " ")[1]) for x in eachmatch(r"\d+ blue", line)]
    return Game(ID, maximum.([reds, greens, blues])...)
end

is_possible(g::Game) = g.reds <= 12 && g.greens <= 13 && g.blues <= 14

games = decode.(lines)
mask = is_possible.(games)
println("Day Two Part A Answer: $(sum(g.ID for g in games[mask]))")

# Day Two, Part B
test = readlines("inputs/day_02_tests.txt")
power(g::Game) = g.reds * g.greens * g.blues
println("Day Two Part B Answer: $(sum(power.(games)))")