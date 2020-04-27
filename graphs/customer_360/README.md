# Customer 360

## Loading from Database

Vertex label and partitioning are disabled, because:

- 18c (= always free autonomous) does not support vertex label
- Filter method (used in analytics examples) is not supported for partitioned graphs

    "partition_while_loading":"by_label",
    "loading":{
      "load_vertex_labels":true,
