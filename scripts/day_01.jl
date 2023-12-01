lines = readlines(".\\inputs\\day_01.txt");

# Day One, Part A
function process_line(line::String)
    number_string = join([char for char ∈ line if char ∈ '1':'9'])
    first_and_last_number = "$(number_string[1])$(number_string[end])"
    return parse(Int, first_and_last_number)
end;

println("Answer to 1a is $(sum(process_line.(lines)))");

# Day One, Part B
regex = r"(\d|one|two|three|four|five|six|seven|eight|nine)";

function as_digit(string)
    return replace(string, "one" => "1", "two" => "2", "three" => "3",
                           "four" => "4", "five" => "5", "six" => "6",
                           "seven" => "7", "eight" => "8", "nine" => "9")
end;

function new_process_line(regex::Regex, line::String)
    # Need overlap=true so that "twoneight" matches two, one, eight
    matches = [match for match in eachmatch(regex, line, overlap=true)]
    first_match, last_match = matches[1][1], matches[end][1]
    number_as_string = "$(as_digit(first_match))$(as_digit(last_match))"
    return parse(Int, number_as_string)
end;

println("Answer to 1b is $(sum(new_process_line.(regex, lines)))");