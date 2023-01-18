# cloudkms-terraform-demo
Cloud KMS demo for managing a keyring, zero or more keys in the keyring, and IAM role bindings on individual keys.

- Create a KMS keyring in the provided project
- Create zero or more keys in the keyring using KMS or imported key material
- Create IAM role bindings for owners, encrypters, decrypters

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| decrypters | List of comma-separated owners for each key declared in set\_decrypters\_for. | `list(string)` | `[]` | no |
| encrypters | List of comma-separated owners for each key declared in set\_encrypters\_for. | `list(string)` | `[]` | no |
| key\_algorithm | The algorithm to use when creating a version based on this template. See the [documentation](https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm) for possible inputs. | `string` | `"GOOGLE_SYMMETRIC_ENCRYPTION"` | no |
| key\_protection\_level | The protection level to use when creating a version based on this template. Default value: "SOFTWARE" Possible values: ["SOFTWARE", "HSM"] | `string` | `"SOFTWARE"` | no |
| key\_rotation\_period | n/a | `string` | `"100000s"` | no |
| keyring | Keyring name. | `string` | n/a | yes |
| keys | Key names. | `list(string)` | `[]` | no |
| import\_key\_material | Will key material be imported? Possible values: yes/no | `string` | n/a | yes |
| labels | Labels, provided as a map | `map(string)` | `{}` | no |
| location | [Location](https://cloud.google.com/kms/docs/locations) for the keyring. | `string` | n/a | yes |
| owners | List of comma-separated owners for each key declared in set\_owners\_for. | `list(string)` | `[]` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| project\_id | Project id where the keyring will be created. | `string` | n/a | yes |
| purpose | The immutable purpose of the CryptoKey. Possible values are ENCRYPT\_DECRYPT, ASYMMETRIC\_SIGN, and ASYMMETRIC\_DECRYPT. | `string` | `"ENCRYPT_DECRYPT"` | no |
| set\_decrypters\_for | Name of keys for which decrypters will be set. | `list(string)` | `[]` | no |
| set\_encrypters\_for | Name of keys for which encrypters will be set. | `list(string)` | `[]` | no |
| set\_owners\_for | Name of keys for which owners will be set. | `list(string)` | `[]` | no |

Each owners, encrypters and decrypters entry can have one of the following values:

***allUsers:*** A special identifier that represents anyone who is on the internet; with or without a Google account.

***allAuthenticatedUsers:*** A special identifier that represents anyone who is authenticated with a Google account or a service account.

***user:{emailid}:*** An email address that represents a specific Google account. For example, jane@example.com or joe@example.com.

***serviceAccount:{emailid}:*** An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.

***group:{emailid}:*** An email address that represents a Google group. For example, admins@example.com.

***domain:{domain}:*** A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.

## Outputs

| Name | Description |
|------|-------------|
| keyring | Self link of the keyring. |
| keyring\_name | Name of the keyring. |
| keyring\_resource | Keyring resource. |
| keys | Map of key name => key self link. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

### Service Account

A service account with one of the following roles must be used to provision
the resources of this module:

- Cloud KMS Admin: `roles/cloudkms.admin` or
- Owner: `roles/owner`

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Key Management Service: `cloudkms.googleapis.com`
