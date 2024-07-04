from typing import Any

import psycopg
from graphviz import Digraph

conn_args = {
    "dbname": "database",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5433,
}


def get_execution_plan(query: Any):
    queries: list[str] = []

    with psycopg.connect(**conn_args, autocommit=True) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            cur.nextset()
            result = cur.fetchone()

            if result:
                plan = result[0][0]["Plan"]
            else:
                plan = None

            return plan


def parse_plan(plan, graph: Digraph, parent_node_id=None):
    node_id = str(id(plan))
    node_label = f"""<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">
            <TR><TD BGCOLOR="lightblue">{plan['Node Type']}</TD></TR>
            <TR><TD>Cost: {plan['Total Cost']}</TD></TR>
            <TR><TD>Rows: {plan['Plan Rows']}</TD></TR>
        </TABLE>>"""

    graph.node(node_id, node_label, shape="box")

    if parent_node_id:
        graph.edge(parent_node_id, node_id)

    for subplan in plan.get("Plans", []):
        parse_plan(subplan, graph, node_id)
