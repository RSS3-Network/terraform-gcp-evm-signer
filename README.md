# Terraform Evm Signer GCP Module

This module helps you deploy a EVM Signer on Google Cloud Platform.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a KMS keyring
- Create a KMS key for asymmetric signing
- Create a service account with the necessary permissions for the cloud run service
- Create a cloud run service

## Usage

```terraform
# todo
```

Then perform the following steps:

1. Run `terraform init` to get the necessary providers.
2. Run `terraform plan` to create the execution plan.
3. Run `terraform apply` to apply the execution plan.
4. Run `terraform destroy` to destroy the resources created by the execution plan.

More examples can be found in the [examples](./examples) directory.

## Inputs

| Name                     | Description                                                                                                                                                           | Type     | Default                             |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ----------------------------------- |
| name                     | The name of the module                                                                                                                                                | `string` | n/a                                 |
| project                  | the project id                                                                                                                                                        | `string` | n/a                                 |
| location                 | the location of kms key ring                                                                                                                                          | `string` | n/a                                 |
| create_key_ring          | if true, create key ring                                                                                                                                              | `bool`   | `true`                              |
| key_ring_name            | the name of the key ring                                                                                                                                              | `string` | n/a                                 |
| create_crypto_key        | if true, create crypto key                                                                                                                                            | `bool`   | `true`                              |
| crypto_key_name          | the name of the crypto key                                                                                                                                            | `string` | n/a                                 |
| create_service_account   | if true, create a service account for the cloud run service                                                                                                           | `bool`   | `true`                              |
| service_account_name     | The name of the service account that will be created if create_service_account is true. If you wish to use an existing service account, use service_account variable. | `string` | `""`                                |
| cloud_run_image          | The image to deploy to Cloud Run                                                                                                                                      | `string` | n/a                                 |
| cloud_run_port           | The port that the container listens on                                                                                                                                | `number` | `8000`                              |
| cloud_run_ingress        | Provides the ingress settings for this Service. On output, returns the currently observed ingress settings, or INGRESS_TRAFFIC_UNSPECIFIED if no revision is active.  | `string` | `"INGRESS_TRAFFIC_ALL"`             |
| cloud_run_resource_limit | The resource limits for the Cloud Run service                                                                                                                         | `object` | `{ "cpu": "1", "memory": "512Mi" }` |
