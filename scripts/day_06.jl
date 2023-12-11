# Parse data
lines = readlines("inputs\\day_06.txt")

struct Race
    time::Int
    distance::Int
end

function parse_line(line::String)
    strings = [x.match for x ∈ eachmatch(r"\s(\d)+\s*", line, overlap=true)]
    return parse.(Int, replace.(strings, " " => ""))
end

times, distances = parse_line.(lines)
races = Race.(times, distances)

# Part A
possible_distances(race::Race) = [(t)*(race.time - t) for t ∈ 0:race.time]
count_wins(race::Race) = sum(possible_distances(race) .> race.distance)
println("Part A answer: $(races .|> count_wins |> prod)")

# Part B
function new_parse_line(line::String)
    return parse(Int, split(replace(line, " " => ""), ":")[2])
end

new_race = Race(new_parse_line(lines[1]), new_parse_line(lines[2]))
println("Part B answer: $(count_wins(new_race))")