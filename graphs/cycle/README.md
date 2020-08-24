# Cycle Detection Demo Dataset

- 1,000 nodes
- Each node has 5 out-going random edges

## Generate Data

Create edges.

```
import networkx as nx
G = nx.random_k_out_graph(1000, 5, 1)
nx.write_edgelist(G, "edges_nolabel.csv", delimiter=",", data=False)
```

Add a label "transfer" to all edges.

```
sed -e '/$/,"transfer"/g' edges_nolabel.csv > edges.csv
```

Ceate nodes.

```
$ sh create_nodes.sh > nodes.csv
```

`create_nodes.sh`
```
#!/bin/bash
COUNT=1
while [ $COUNT -le 1000 ]
do
  echo $COUNT,\"Account\"
  let COUNT++
done
```

## Pre-load Setting 

For pre-loading the graph into Graph Server, add these two entry to `pgx.conf`.

    {
    
      "authorization": [
        "pgx_permissions": [
        , { "preloaded_graph": "Cycle", "grant": "READ"}    <--
      
      "preload_graphs": [
      , {"path": "/graphs/cycle/config.json", "name": "Cycle"}    <--
