# pip install memory-profiler
from memory_profiler import memory_usage


def function_to_test():
    # Your logic here; for example:
    a = [0] * (10**6)  # Allocates memory
    return sum(a)


# Sample memory usage with a short interval to catch transient peaks.
if __name__ == "__main__":
    mem_usage = memory_usage(function_to_test, interval=0.01)
    peak_memory = max(mem_usage)
    print(f"Peak memory usage: {peak_memory:.2f} MiB")
