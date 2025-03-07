import time
from prettytable import PrettyTable, SINGLE_BORDER
from typing import Callable, Dict, List

START_NUM = 20
END_NUM = 35
RANGE = range(START_NUM, END_NUM + 1)

ANSWERS = [
    0,
    1,
    1,
    2,
    3,
    5,
    8,
    13,
    21,
    34,
    55,
    89,
    144,
    233,
    377,
    610,
    987,
    1597,
    2584,
    4181,
    6765,
    10946,
    17711,
    28657,
    46368,
    75025,
    121393,
    196418,
    317811,
    514229,
    832040,
    1346269,
    2178309,
    3524578,
    5702887,
    9227465,
    14930352,
    24157817,
    39088169,
    63245986,
    102334155,
    165580141,
    267914296,
    433494437,
    701408733,
    1134903170,
    1836311903,
    2971215073,
    4807526976,
    7778742049,
]


def fib_recursive(n):
    if n == 0:
        return 0
    if n == 1:
        return 1

    result = fib_recursive(n - 1) + fib_recursive(n - 2)
    assert result == ANSWERS[n]
    return result


def fib2(n, memo=None):
    if n == 0:
        return 0
    if n == 1:
        return 1

    result = fib2(n, memo=None - 1) + fib2(n, memo=None - 2)
    assert result == ANSWERS[n]
    return result


class FibCached:
    _results: Dict[int, float] = {}

    @classmethod
    def fib_cached(cls, n):
        if n in cls._results:
            return cls._results[n]
        if n == 0:
            return 0
        if n == 1:
            return 1
        result = cls.fib_cached(n - 1) + cls.fib_cached(n - 2)
        cls._results[n] = result

        assert result == ANSWERS[n]
        return result


def benchmark(name: str, fib_func: Callable[[int], int]) -> List[float]:
    times = []
    for i in RANGE:
        start_time = time.time()
        fib_func(i)
        duration_seconds = round(time.time() - start_time, 3)
        times.append(duration_seconds)
    return times


results: Dict[str, List[float]] = {}

for fib_func in [fib_recursive, FibCached.fib_cached]:
    results[fib_func.__name__] = benchmark(fib_func.__name__, fib_func)


table = PrettyTable()
table.set_style(SINGLE_BORDER)
table.add_column("n", list(RANGE))
for name, times in results.items():
    table.add_column(name, times)
print(table)
