
# Pseudorandom

PseudoRandom is a package for creating lists of pseudorandom numbers — lists of integers or floats that resemble lists produced by random means, even though they are generated deterministically.  This resemblance can be made precise using various statistical tests.

In this connection, we repeat John von Neumann's joke: *Anyone who attempts to generate random numbers by deterministic means is, of course, living in a state of sin.*

**Examples:**

```
  floatSequence 3 7 (0, 1) |> List.map (roundTo 4)
    == [0.448,0.0988,0.246]

  integerSequence 3 8
    == [123092948, 28845728, 98310392]
```

**NOTE:** the seed must be a positive integer.

We use the linear congruential generator of Lewis, Goodman, and Miller (1) for the integerSequence function. For floatSequence we use the triple linear congruential generator of (2).

**References**

1.  <https://www.math.arizona.edu/~tgk/mc/book_chap3.pdf>

2.  <http://www.ams.org/journals/mcom/1999-68-225/S0025-5718-99-00996-5/S0025-5718-99-00996-5.pdf>

3.  Von Neumann, John (1951). "Various techniques used in connection with random digits" (PDF). National Bureau of Standards Applied Mathematics Series. 12: 36–38.
