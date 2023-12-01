lines = readlines(".\\inputs\\day_01.txt");

# Day One, Part A
function decode(line::String)
    digits = join([char for char ∈ line if char ∈ '1':'9'])
    return parse(Int, "$(digits[1])$(digits[end])")
end;

println("Answer to 1a: $(sum(decode.(lines)))");

# Day One, Part B
regex = r"(\d|one|two|three|four|five|six|seven|eight|nine)";

function as_digit(string)
    return replace(string, "one" => "1", "two" => "2", "three" => "3",
                           "four" => "4", "five" => "5", "six" => "6",
                           "seven" => "7", "eight" => "8", "nine" => "9")
end;

function decode(regex::Regex, line::String)
    # Need overlap=true so that "twoneight" matches two, one, eight
    matches = eachmatch(regex, line, overlap=true) |> collect
    first_match, last_match = matches[1][1], matches[end][1]
    number_as_string = "$(as_digit(first_match))$(as_digit(last_match))"
    return parse(Int, number_as_string)
end;

println("Answer to 1b: $(sum(decode.(regex, lines)))");