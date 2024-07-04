from scripts.db_analysis.graph_generator import generate_graph
from scripts.db_analysis.sql_processing import get_execution_plan
from scripts.utils.get_file_content import get_file_content

sql_file_path = "./sql/queries/query_1/query_1_indexed_custom.sql"
query = get_file_content(sql_file_path)
plan = get_execution_plan(query)
generate_graph(plan)
