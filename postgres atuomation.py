import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

# Load the .env file
load_dotenv()

# Access environment variables


DATABASE = os.getenv("DATABASE")
USER = os.getenv("USER")
PASSWORD = os.getenv("PASSWORD")
HOST = os.getenv("HOST")
PORT = os.getenv("PORT")
CSV_FILE = os.getenv("CSV_FILE")
TABLE_NAME = os.getenv("TABLE_NAME")

# Step 1: Read the CSV file
df = pd.read_csv(CSV_FILE)

# Clean column names to make them SQL-friendly (optional)
df.columns = (
    df.columns.str.strip().str.replace(" ", "_").str.replace("[^a-zA-Z0-9_]", "")
)

# Step 2: Map Pandas dtypes to PostgreSQL types
dtype_mapping = {
    "int64": "INTEGER",
    "float64": "REAL",
    "object": "TEXT",
    "bool": "BOOLEAN",
    "datetime64[ns]": "DATE",
}

# Generate the CREATE TABLE statement dynamically
columns = []
for col, dtype in df.dtypes.items():
    pg_type = dtype_mapping.get(str(dtype), "TEXT")  # Default to TEXT
    columns.append(f"{col} {pg_type}")

columns_sql = ", ".join(columns)
create_table_sql = f"CREATE TABLE IF NOT EXISTS {TABLE_NAME} ({columns_sql});"

# Step 3: Connect to PostgreSQL and create the table
engine = create_engine(f"postgresql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}")
with engine.connect() as conn:
    # Create table
    conn.execute(text(create_table_sql))

# Step 4: Load the data into the PostgreSQL table
df.to_sql(TABLE_NAME, engine, if_exists="append", index=False)

print(f"Data from {CSV_FILE} successfully loaded into {TABLE_NAME}.")
print(f"Data from {CSV_FILE} successfully loaded into {TABLE_NAME}.")
print(f"Data from {CSV_FILE} successfully loaded into {TABLE_NAME}.")
