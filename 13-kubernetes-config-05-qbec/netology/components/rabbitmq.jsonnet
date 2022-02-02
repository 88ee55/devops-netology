local p = import '../params.libsonnet';
local params = p.components.rabbitmq;

[
  {
    "kind": "Deployment",
    "apiVersion": "apps/v1",
    "metadata": {
      "name": "rabbitmq"
    },
    "spec": {
      replicas: params.replicas,
      "selector": {
        "matchLabels": {
          "component": "rabbitmq"
        }
      },
      "strategy": {
        "type": "Recreate"
      },
      "template": {
        "metadata": {
          "labels": {
            "component": "rabbitmq"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "rabbitmq",
              "image": "rabbitmq:3",
            }
          ]
        }
      }
    }
  }
]