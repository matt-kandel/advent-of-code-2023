# Setup
lines = readlines("inputs/day_07.txt")

mutable struct Hand
    cards::Vector{Int}
    bid::Int
    rank::Int
end

function parse_line(line)
    cards, bid = split(line)
    bid = parse(Int, bid)
    cards = string.(collect(cards))
    cards = replace(cards, "T" => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14)
    cards = parse.(Int, string.(cards))
    return Hand(cards, bid, 1)
end

hands = parse_line.(lines)

# Part A
function make_card_count_dict(hand::Hand)
    Dict([(card, count(==(card), hand.cards)) for card in hand.cards])
end

function score(hand::Hand)
    # This function is based on the type of hand
    # it won't break ties
    card_count_dict = make_card_count_dict(hand)

    # sort number of card matches from highest to lowest
    matches = sort(collect(values(card_count_dict)), rev=true)
    if matches[1] == 1 #"High card"
        score = 1
    elseif matches[1] == 2 && matches[2] < 2 #One pair
        score = 2
    elseif matches[1] == 2 && matches[2] == 2 #Two pair
        score = 3
    elseif matches[1] == 3 && matches[2] < 2 #Three of a kind
        score = 4
    elseif matches[1] == 3 && matches[2] == 2 #Full house
        score = 5
    elseif matches[1] == 4 #Four of a kind
        score = 6
    elseif matches[1] == 5 #Five of a kind
        score = 7
    end
end

function play_round(hand1::Hand, hand2::Hand)
    if score(hand1) > score(hand2)
        hand1.rank += 1
    elseif score(hand1) < score(hand2)
        hand2.rank += 1
    else
        tiebreaker(hand1, hand2)
    end
end

function tiebreaker(hand1::Hand, hand2::Hand)
    i = 1
    while hand1.cards[i] == hand2.cards[i]
        i += 1
    end
    hand1.cards[i] > hand2.cards[i] ? hand1.rank += 1 : hand2.rank += 1
end

for i in eachindex(hands)
    for j in eachindex(hands)
        if i < j
            play_round(hands[i], hands[j])
        end
    end
end

println("Part A answer: $(sum(hand.rank .* hand.bid for hand in hands))")