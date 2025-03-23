import argparse
import itertools
import random
import re
import sys

moves = list(itertools.chain.from_iterable((m, f"{m}'", f"{m}2") for m in "BRFLUD"))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("count", type=int, nargs="?", default=20)
    args = parser.parse_args()
    i = 0
    while True:
        i += 1
        scramble = " ".join(random.choice(moves) for _ in range(args.count))
        if not re.search(r"(\w)[ 2']+\1", scramble):
            break
    print(f"{i}: {scramble}")


if __name__ == "__main__":
    main()
