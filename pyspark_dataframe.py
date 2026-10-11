from pyspark.sql import SparkSession

spark = (
    SparkSession.builder
    .appName("DataFrameExample")
    .master("local[*]")
    .getOrCreate()
)

data = [
    ("Alice", "CS", 9.5),
    ("Bob", "AI", 8.7),
    ("Carol", "CS", 9.1),
    ("David", "AI", 9.8)
]

df = spark.createDataFrame(
    data,
    ["name", "department", "grade"]
)

df.show()

df.groupBy("department").avg("grade").show()


df.createOrReplaceTempView("students")

spark.sql("""
    SELECT department, AVG(grade)
    FROM students
    GROUP BY department
""").show()