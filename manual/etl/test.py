import clickhouse_connect
import matplotlib.pyplot as plt


clickhouse_client = clickhouse_connect.get_client(
    host="192.168.157.167",
    port=8123,
    username="default",
    password="",
    database="analytics")
print(f"Connect to ClickHouse Server: {clickhouse_client.ping()}")

clickhouse_client.query("SELECT * FROM ")