#lang forge/bsl "cm" "rke3w1masurrddks@gmail.com"

abstract sig Player{}
sig Batter extends Player{
    // Represents the next Batter in the Batting Lineup
    onDeck: one Batter
}

// Represents the states of the half-inning
sig AtBat{
    outs: one Int,
    batterUp: one Player,
    runs: one Int,
    next: lone AtBat
}

abstract sig Base{
    runner: pfunc AtBat -> Player
}

one sig firstBase extends Base{}
one sig secondBase extends Base{}
one sig thirdBase extends Base{}

one sig noRunner extends Player{}

// sig PositionPlayer extends Player{}
// one sig P extends PositionPlayer{}
// one sig C extends PositionPlayer{}
// abstract sig Outfielder extends PositionPlayer{}
// one sig LF extends Outfielder{}
// one sig CF extends Outfielder{}
// one sig RF extends Outfielder{}
// abstract sig Infielder extends PositionPlayer{}
// one sig firstB extends Infielder{}
// one sig secondB extends Infielder{}
// one sig SS extends Infielder{}
// one sig thirdB extends Infielder{}


pred leadOffAtBat[leadOff: AtBat]{
    // Defines the Initial AtBat of the Inning
    no b: AtBat | b.next=leadOff
    all base: Base | base.runner[leadOff] = noRunner
    leadOff.runs = 0
    leadOff.outs = 0
}

pred lastAtBat[last: AtBat]{
    // 
    no b: AtBat | last.next=b
    all b: AtBat | {b!=last implies b.outs<3}
    last.outs=3 // TODO: But the last AtBat isn't really an AtBat if the half of the inning is already over
}

pred wellformedTeams{
    all b: Batter | {some ab: Batter|ab.onDeck=b and ab!=b} and {some bc: Batter|b.onDeck=bc and b!=bc}
    all a,b: Batter | reachable[a,b,onDeck]
}

pred atBatTransition[atBatPrev : AtBat, atBatNext : AtBat]{
    // A valid play must occur between every atBat
    atBatNext.batterUp = atBatPrev.batterUp.onDeck
    strikeout[atBatPrev, atBatNext] or popout[atBatPrev, atBatNext] or groundout[atBatPrev, atBatNext] or 
        single[atBatPrev, atBatNext] or double[atBatPrev, atBatNext] or triple[atBatPrev, atBatNext] or 
        homerun[atBatPrev, atBatNext] // or walk[atBatPrev, atBatNext]
}

pred strikeout[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = add[atBatPrev.outs, 1]
    atBatNext.runs = atBatPrev.runs
    all b : Base | b.runner[atBatPrev] = b.runner[atBatNext]
}

pred popout[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = add[atBatPrev.outs, 1]
    atBatNext.runs = atBatPrev.runs
    all b : Base | b.runner[atBatPrev] = b.runner[atBatNext]
}

pred groundout[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = add[atBatPrev.outs, 1]
    atBatNext.runs = atBatPrev.runs
    all b : Base | b.runner[atBatPrev] = b.runner[atBatNext]
}

pred single[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = atBatPrev.outs
    atBatNext.runs = add[atBatPrev.runs, {thirdBase.runner[atBatPrev] != noRunner => 1 else 0}]

    // Other batterUps advance one base
    secondBase.runner[atBatNext] = firstBase.runner[atBatPrev]
    thirdBase.runner[atBatNext] = secondBase.runner[atBatPrev]

    // Batter advances to first base
    firstBase.runner[atBatNext] = atBatPrev.batterUp
}

pred double[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = atBatPrev.outs
    atBatNext.runs = add[atBatPrev.runs, {secondBase.runner[atBatPrev] != noRunner => 1 else 0},
                                      {thirdBase.runner[atBatPrev] != noRunner => 1 else 0}]

    // TODO: Should I refer to thirdBase like this or from firstBase.next.next?
    thirdBase.runner[atBatNext] = firstBase.runner[atBatPrev]

    // Batter advances to second base
    secondBase.runner[atBatNext] = atBatPrev.batterUp

    // First Base is empty
    firstBase.runner[atBatNext] = noRunner
}

pred triple[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = atBatPrev.outs
    atBatNext.runs = add[atBatPrev.runs, {firstBase.runner[atBatPrev] != noRunner => 1 else 0},
                                      {secondBase.runner[atBatPrev] != noRunner => 1 else 0}, 
                                      {thirdBase.runner[atBatPrev] != noRunner => 1 else 0}]

    // Batter advances to third base
    thirdBase.runner[atBatNext] = atBatPrev.batterUp

    // All other bases are empty
    all b : Base | {b != thirdBase} => {b.runner[atBatNext] = noRunner}
}

pred homerun[atBatPrev : AtBat, atBatNext : AtBat]{
    atBatNext.outs = atBatPrev.outs
    atBatNext.runs = add[atBatPrev.runs, {firstBase.runner[atBatPrev] != noRunner => 1 else 0},
                                      {secondBase.runner[atBatPrev] != noRunner => 1 else 0}, 
                                      {thirdBase.runner[atBatPrev] != noRunner => 1 else 0}, 1]

    // All bases are now empty
    all b : Base | b.runner[atBatNext] = noRunner
}

pred walk[atBatPrev : AtBat, atBatNext : AtBat]{
    // TODO: Is there anything that makes this different than a single? Yes, other runners don't move unless they have to
    atBatNext.outs = atBatPrev.outs
    atBatNext.runs = atBatPrev.runs

}

pred traces{
    wellformedTeams
    one ab : AtBat | leadOffAtBat[ab]
    all ab : AtBat | {not lastAtBat[ab]} => {atBatTransition[ab, ab.next]}
}

run {traces} for exactly 9 Batter, 6 Int, 18 AtBat for {next is linear}