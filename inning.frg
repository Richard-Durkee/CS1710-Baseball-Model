#lang forge/bsl

sig Inning{

}

sig Player{}

abstract sig Team{}
one sig Offense extends Team{}
one sig Defense extends Team{}