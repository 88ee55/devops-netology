# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1

1. [DataSources](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/provider.go#L186)
[Resources](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/provider.go#L453)


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
