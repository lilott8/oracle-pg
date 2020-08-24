## Pre-load Setting 

For pre-loading the graph into Graph Server, add these two entry to `pgx.conf`.

    {
    
      "authorization": [
        "pgx_permissions": [
        , { "preloaded_graph": "Mule Account", "grant": "READ"}    <--
      
      "preload_graphs": [
      , {"path": "/graphs/mule_account/graph.pgx.json", "name": "Mule Account"}    <--
