#lang forge/bsl

sig AtBat{
    outs: one Int
    batter: one Player
    runs: one Int
    next: lone AtBat
}

abstract sig Base{
    runner: pfunc AtBat -> Player
    next: one Base
}

one sig 1stBase extends Base{}
one sig 2ndBase extends Base{}
one sig 3rdBase extends Base{}

abstract sig Player{}
sig Batter extends Player{
    onDeck: one Batter
    inTheHole: one Batter
}
sig PositionPlayer extends Player{}
one sig P extends PositionPlayer{}
one sig C extends PositionPlayer{}
abstract sig Outfielder extends PositionPlayer{}
one sig LF extends Outfielder{}
one sig CF extends Outfielder{}
one sig RF extends Outfielder{}
abstract sig Infielder extends PositionPlayer{}
one sig 1B extends Infielder{}
one sig 2B extends Infielder{}
one sig SS extends Infielder{}
one sig 3B extends Infielder{}


pred leadOff[ab: AtBat]{
    no b: AtBat | b.next=ab
    all base: Base | no base.runner[ab]
    
}

pred lastBatter[last: AtBat]{
    no b: AtBat | last.next=b
    all b: AtBat | {b.next=last implies b.outs<3}
    last.outs=3
}

pred wellformedTeams{
    all b: Batter | {some ab: Batter|ab.onDeck=b and ab!=b} and {some bc: Batter|b.onDeck=bc and b!=bc}
    all b: Batter | b.inTheHole=b.onDeck.onDeck
    all a,b: Batter | reachable[a,b,onDeck] and reachable
}

pred atBat{

}

pred strikeout{

}

pred popout{

}

pred groundout{

}

pred double{

}

pred single{

}

pred triple{

}

pred walk{

}

pred traces{}