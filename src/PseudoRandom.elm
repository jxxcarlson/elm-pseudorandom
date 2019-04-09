module PseudoRandom exposing (integerSequence, floatSequence, m0, roundTo)

{-| This module provides two pseudo-random number generators,
floatSequence and integerSequence. The first produces
a list of n floating point numbers in a specified range.
The second produces a list of positive integers in the range
1 to m0 = 214748364. A pseudo-random sequence is a sequence
of numbers that resembles a random sequence even though it is
produced by deterministic means. The notion "resembles" can
be made precise using various statistical tests.

Examples:

floatSequence 3 7 (0, 1) |> List.map (roundTo 4) == [0.448,0.0988,0.246]

integerSequence 3 8 == [123092948, 28845728, 98310392]

We use the linear congruential generator of (1), Lewis, Goodman, and Miller, for the integerSequence function.
For floatSequence we use the generator triple linear congruential generator
of (2).

References:

1.  <https://www.math.arizona.edu/~tgk/mc/book_chap3.pdf>

2.  <http://www.ams.org/journals/mcom/1999-68-225/S0025-5718-99-00996-5/S0025-5718-99-00996-5.pdf>

@docs integerSequence, floatSequence, m0, roundTo

-}


{-| Using the seed, produce a list of n floats in the range [a,b)
-}
floatSequence : Int -> Int -> ( Float, Float ) -> List Float
floatSequence n seed ( a, b ) =
    urandSequence n seed
        |> List.map (\x -> (b - a) * x + a)


{-| Using the seed, produce a list of n integers k, where 0 <= k < m0.
-}
integerSequence : Int -> Int -> List Int
integerSequence n seed =
    List.take n <| orbit f0 n seed


{-| Using the seed, produce a list of n floating point numbers in the range [0,1)
-}
urandSequence : Int -> Int -> List Float
urandSequence n seed =
    let
        s1 =
            integerSequence_ f1 n seed

        s2 =
            integerSequence_ f2 n seed

        s3 =
            integerSequence_ f3 n seed

        m1_ =
            toFloat m1

        m2_ =
            toFloat m2

        m3_ =
            toFloat m3
    in
        List.map3 (\x1 x2 x3 -> (toFloat x1) / m1_ + (toFloat x2) / m2_ + (toFloat x3) / m3_) s1 s2 s3
            |> List.map mod1


integerSequence_ : (Maybe Int -> Int) -> Int -> Int -> List Int
integerSequence_ f n seed =
    List.take n <| orbit f n seed


{-| Repeatedly apply a function f : Maybe Int -> Int
to a strating value to produce a List Int.

> orbit f1 3 1
> [20829,18177,10727] : List Int

-}
orbit : (Maybe Int -> Int) -> Int -> Int -> List Int
orbit f n startingValue =
    orbitAux f (n + 5) [ startingValue ]
        |> List.take n


orbitAux : (Maybe Int -> Int) -> Int -> List Int -> List Int
orbitAux f n ns =
    case n == 0 of
        True ->
            ns

        False ->
            orbitAux f (n - 1) ((f (List.head ns)) :: ns)


{-| Modular functions for the PRNGs.
-}
f0 : Maybe Int -> Int
f0 maybeInt =
    case maybeInt of
        Nothing ->
            1

        Just k ->
            modBy m0 (a0 * k)


f1 : Maybe Int -> Int
f1 maybeInt =
    case maybeInt of
        Nothing ->
            1

        Just k ->
            modBy m1 (a1 * k)


f2 : Maybe Int -> Int
f2 maybeInt =
    case maybeInt of
        Nothing ->
            1

        Just k ->
            modBy m2 (a2 * k)


f3 : Maybe Int -> Int
f3 maybeInt =
    case maybeInt of
        Nothing ->
            1

        Just k ->
            modBy m3 (a3 * k)


{-| The largest intnger that integerSequence will produce is m0 - 1.
-}
m0 : Int
m0 =
    214748364


m1 : Int
m1 =
    30269


m2 : Int
m2 =
    30307


m3 : Int
m3 =
    30323


a0 : Int
a0 =
    16807


a1 : Int
a1 =
    171


a2 : Int
a2 =
    172


a3 : Int
a3 =
    170



{- Utility functions -}


{-| mod1 x is the fractional part of the floating point
number x, i.e., -1 < x < 1. If x >= 0 then mod11 x >= 0.
-}
mod1 : Float -> Float
mod1 x =
    x - (toFloat <| truncate <| x)


{-| Use this function if all those digits in the output of
floatSequence bother you.

roundTo 2 1.2345 == 1.23

-}
roundTo : Int -> Float -> Float
roundTo k x =
    let
        kk =
            toFloat k
    in
        x * 10.0 ^ kk |> round |> toFloat |> (\y -> y / 10.0 ^ kk)
