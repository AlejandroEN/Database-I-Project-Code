from typing import Any

from graphviz import Digraph

from scripts.db_analysis.sql_processing import parse_plan


def generate_graph(plan: Any, filename: str = "plan"):
    graph = Digraph(comment="Query Execution Plan")
    graph.attr(dpi="300")
    parse_plan(plan, graph)
    graph.render(filename, format="png", view=True)
