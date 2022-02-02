local base = import './base.libsonnet';

base {
  components +: {
    rabbitmq +: {
      replicas: 1,
    },
  }
}