DEF RNG_NAME = 'pcg32'
DEF RNG_ADVANCEABLE = 1
DEF RNG_JUMPABLE = 0
DEF RNG_STATE_LEN = 4
DEF RNG_SEED = 2
DEF NORMAL_METHOD = 'zig'

cdef extern from "distributions.h":
    ctypedef struct pcg_state_setseq_64:
        uint64_t state
        uint64_t inc

    ctypedef pcg_state_setseq_64 pcg32_random_t

    cdef struct s_aug_state:
        pcg32_random_t *rng
        binomial_t *binomial

        int has_gauss, shift_zig_random_int, has_uint32
        double gauss
        uint64_t zig_random_int
        uint32_t uinteger

    ctypedef s_aug_state aug_state

    cdef void set_seed(aug_state* state, uint64_t seed, uint64_t inc)

    cdef void advance(aug_state* state, uint64_t delta)

ctypedef uint64_t rng_state_t

ctypedef pcg32_random_t rng_t

cdef object _get_state(aug_state state):
    return (state.rng.state, state.rng.inc)

cdef object _set_state(aug_state *state, object state_info):
    state.rng.state = state_info[0]
    state.rng.inc = state_info[1]

DEF CLASS_DOCSTRING = """
RandomState(seed=None)

Container for the PCG-32 pseudo random number generator.

PCG-32 is a 64-bit implementation of O'Neill's permutation congruential 
generator ([1]_, [2]_). PCG-32 has a period of 2**64 and supports advancing 
an arbitrary number of steps as well as 2**63 streams.

`pcg32.RandomState` exposes a number of methods for generating random
numbers drawn from a variety of probability distributions. In addition to the
distribution-specific arguments, each method takes a keyword argument
`size` that defaults to ``None``. If `size` is ``None``, then a single
value is generated and returned. If `size` is an integer, then a 1-D
array filled with generated values is returned. If `size` is a tuple,
then an array with that shape is filled and returned.

*No Compatibility Guarantee*
'pcg32.RandomState' does not make a guarantee that a fixed seed and a
fixed series of calls to 'pcg32.RandomState' methods using the same
parameters will always produce the same results. This is different from
'numpy.random.RandomState' guarantee. This is done to simplify improving
random number generators.  To ensure identical results, you must use the
same release version.

Parameters
----------
seed : {None, long}, optional
    Random seed initializing the pseudo-random number generator.
    Can be an integer in [0, 2**64] or ``None`` (the default).
    If `seed` is ``None``, then `xorshift1024.RandomState` will try to read data
    from ``/dev/urandom`` (or the Windows analogue) if available or seed from
    the clock otherwise.  
inc : {None, int}, optional
    Stream to return.  
    Can be an integer in [0, 2**64] or ``None`` (the default).  If `inc` is 
    ``None``, then 1 is used.  Can be used with the same seed to 
    produce multiple streams using other values of inc.
    
Notes
-----
Supports the method advance to advance the PRNG an arbitrary number of steps. 
The state of the PCG-32 PRNG is represented by 2 64-bit unsigned integers.

See pcg64 for a similar implementation with a larger period.

References
----------
.. [1] "PCG, A Family of Better Random Number Generators",
       http://www.pcg-random.org/
.. [2] O'Neill, Melissa E. "PCG: A Family of Simple Fast Space-Efficient 
       Statistically Good Algorithms for Random Number Generation"
"""