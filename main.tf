locals {
  keys_by_name = zipmap(var.keys, slice(google_kms_crypto_key.key[*].id, 0, length(var.keys)))
  keys_by_name_with_imported_material = zipmap(var.keys, slice(google_kms_crypto_key.key_with_imported_material[*].id, 0, length(var.keys)))
}

resource "google_kms_key_ring" "key_ring" {
  name     = var.keyring
  project  = var.project_id
  location = var.location
}

# Creates keys with default key material
resource "google_kms_crypto_key" "key" {
  count           = length(var.keys)
  name            = var.keys[count.index]
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.key_rotation_period
  purpose         = var.purpose
  # For keys not needing imported key material, skip_initial_version_creation is set to false.
  skip_initial_version_creation = false

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

# Creates keys for which key material needs to be imported later through the import job created in the next resource block
resource "google_kms_crypto_key" "key_with_imported_material" {
  count           = length(var.keys)
  name            = format("%s_with_imported_material", var.keys[count.index])
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.key_rotation_period
  purpose         = var.purpose
  # For keys needing imported key material, skip_initial_version_creation is set to true.
  skip_initial_version_creation = true

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

# creates the job for importing key material. Actual import needs to happen through the CLI by invoking the job.
resource "google_kms_key_ring_import_job" "import-job" {
  key_ring = google_kms_key_ring.key_ring.id
  import_job_id = "my-import-job"

  import_method = "RSA_OAEP_3072_SHA1_AES_256"
  protection_level = "SOFTWARE"
}

resource "google_kms_crypto_key_iam_binding" "owners" {
  count         = length(var.set_owners_for)
  role          = "roles/owner"
  crypto_key_id = local.keys_by_name[var.set_owners_for[count.index]]
  members       = compact(split(",", var.owners[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  count         = length(var.set_decrypters_for)
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = local.keys_by_name[var.set_decrypters_for[count.index]]
  members       = compact(split(",", var.decrypters[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  count         = length(var.set_encrypters_for)
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = local.keys_by_name[element(var.set_encrypters_for, count.index)]
  members       = compact(split(",", var.encrypters[count.index]))
}

terraform {
  backend "gcs" {
    bucket  = "aroonavtfdemo"
    prefix  = "terraform/state"
  }
}
