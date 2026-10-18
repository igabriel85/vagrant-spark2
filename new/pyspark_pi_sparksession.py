#!/usr/bin/env python3

"""
Monte Carlo Pi Estimation using Apache Spark 4.x

Usage:
    spark-submit --master local[2] pi.py [partitions]

Example:
    spark-submit --master local[4] pi.py 8
"""

import sys
import time
from random import random
from operator import add

from pyspark.sql import SparkSession


def inside_circle(_):
    """Return 1 if a randomly generated point is inside the unit circle."""
    x = random() * 2 - 1
    y = random() * 2 - 1

    return 1 if x * x + y * y <= 1 else 0


def main():
    # Number of partitions (default: 2)
    partitions = int(sys.argv[1]) if len(sys.argv) > 1 else 2

    if partitions < 1:
        raise ValueError("Number of partitions must be positive")

    # Number of Monte Carlo samples
    n = 100000 * partitions

    # Initialize Spark
    spark = (
        SparkSession.builder
        .appName("PythonPi")
        .getOrCreate()
    )

    sc = spark.sparkContext

    try:
        print("=" * 50)
        print("Apache Spark - Monte Carlo Pi Estimation")
        print("=" * 50)

        print(f"Spark version: {spark.version}")
        print(f"Master: {sc.master}")
        print(f"Partitions: {partitions}")
        print(f"Samples: {n:,}")
        print(f"Default parallelism: {sc.defaultParallelism}")

        start_time = time.perf_counter()

        # Distribute samples across Spark partitions
        rdd = sc.parallelize(range(n), partitions)

        # Map each sample to 0 or 1 and aggregate
        count = rdd.map(inside_circle).reduce(add)

        # Estimate Pi
        pi_estimate = 4.0 * count / n

        elapsed = time.perf_counter() - start_time

        print("\nResults")
        print("-" * 50)
        print(f"Points inside circle: {count:,}")
        print(f"Estimated Pi: {pi_estimate:.8f}")
        print(f"Execution time: {elapsed:.4f} seconds")

    finally:
        spark.stop()


if __name__ == "__main__":
    main()