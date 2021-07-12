# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1

1. [Задача 1.1](https://github.com/hashicorp/terraform-provider-aws/tree/main/aws)

2.
```
		"name": {
			Type:          schema.TypeString,
			Optional:      true,
			Computed:      true,
			ForceNew:      true,
			ConflictsWith: []string{"name_prefix"},
		},

		"name_prefix": {
			Type:          schema.TypeString,
			Optional:      true,
			Computed:      true,
			ForceNew:      true,
			ConflictsWith: []string{"name"},
		},
```

Максимальная длина 80 символов

```
re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
```
