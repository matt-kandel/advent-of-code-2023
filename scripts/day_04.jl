lines = readlines("inputs\\day_04.txt")

struct Card
    ID::Int
    winning_numbers::Vector{Int}
    my_numbers::Vector{Int}
end

function decode(line)
    # Turn a line of text into a Card object
    ID = replace(split(line, ":")[1], " " => "", "Card " => "")
    ID = parse(Int, ID)
    cards = split(line, ":")[2]
    winning_card, my_card = split(cards, "|")
    winning_numbers = split(winning_card, " ")
    my_numbers = split(my_card, " ")
    winning_numbers = [x for x in winning_numbers if x != ""]
    my_numbers = [x for x in my_numbers if x != ""]
    winning_numbers = parse.(Int, winning_numbers)
    my_numbers = parse.(Int, my_numbers)
    return Card(ID, winning_numbers, my_numbers)
end

cards = decode.(lines)

function count_matches(card::Card)
    matches = 0
    for number in card.winning_numbers
        if number in card.my_numbers
            matches += 1
        end
    end
    return matches
end

function score(matches)
    if matches > 0
        return 2^(matches-1)
    elseif matches == 0
        return 0
    end
end

function solve(line)
    card = decode(line)
    return score(count_matches(card))
end

println("Part A answer: $(sum(solve.(lines)))")

# Part B
reference_deck = decode.(lines) # Immutable, depends on staying in proper order
cards_to_process = decode.(lines) # Mutable, will go do zero
processed_cards = Card[]

function identify_cards_to_copy(card::Card)
    # Takes in a Card, returns the IDs of the cards you'll copy
    matches = count_matches(card)
    return card.ID .+ [x for x in 1:matches]
end

create_copy(ID::Int) = reference_deck[ID]

# This while loop takes 25 seconds, but at least it produces the right answer
while length(cards_to_process) > 0
    card = popfirst!(cards_to_process)
    IDs = identify_cards_to_copy(card)
    new_cards = create_copy.(IDs)
    insert!(processed_cards, 1, card)
    for new_card in new_cards
        insert!(cards_to_process, 1, new_card)
    end
end

println("Part B answer: $(length(processed_cards))")