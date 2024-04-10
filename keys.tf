resource "google_kms_key_ring" "key_ring" {
  name     = var.key_ring_name
  location = var.region
}

resource "google_kms_crypto_key" "vm_key" {
  name            = "vm-key"
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "2592000s"
  purpose         = "ENCRYPT_DECRYPT"
}

resource "google_kms_crypto_key" "sql_key" {
  name            = "sql-key"
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "2592000s"
  purpose         = "ENCRYPT_DECRYPT"
}

resource "google_kms_crypto_key" "storage_key" {
  name            = "storage-key"
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "2592000s"
  purpose         = "ENCRYPT_DECRYPT"
}


resource "google_project_service_identity" "cloud_sql" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"
}

resource "google_kms_crypto_key_iam_binding" "encrypter_decrypter_binding" {
  crypto_key_id = google_kms_crypto_key.storage_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${var.sql_service_account_email}",
  ]

}

resource "google_kms_crypto_key_iam_binding" "encrypter_decrypter_binding_sql" {
  crypto_key_id = google_kms_crypto_key.sql_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_project_service_identity.cloud_sql.email}",
  ]

}

resource "google_kms_crypto_key_iam_binding" "encrypter_decrypter_binding_vm" {
  crypto_key_id = google_kms_crypto_key.vm_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${var.vm_service_account_email}",
  ]
}
