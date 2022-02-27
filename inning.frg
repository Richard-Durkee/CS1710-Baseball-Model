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

sig Player{}

abstract sig Team{}
one sig Offense extends Team{}
one sig Defense extends Team{}

pred leadOff[ab: AtBat]{
    no b: AtBat | b.next=ab
    all base: Base | no base.runner[ab]
    
}

pred lastBatter[last: AtBat]{
    no b: AtBat | last.next=b
    all b: AtBat | {b.next=last implies b.outs<3}
    last.outs=3
}