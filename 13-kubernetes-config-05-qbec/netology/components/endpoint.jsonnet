local p = import '../params.libsonnet';
local params = p.components.endpoint;

[
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "rabbitmq"
    },
    "spec": {
      "selector": {
        "component": "rabbitmq"
      },
      "ports": [
        {
          "port": 5672
        }
      ]
    }
  },
]