# Курсовая работа по итогам модуля «DevOps и системное администрирование»

1. Процесс установки и настройки ufw 

Проверим статус работы `ufw`:

```bash
roman@roman-VirtualBox:~$ sudo ufw status
Status: inactive
```

Активируем `ufw` и снова проверим статус работы:

```bash
roman@roman-VirtualBox:~$ sudo ufw enable
Firewall is active and enabled on system startup
roman@roman-VirtualBox:~$ sudo ufw status
Status: active
```

Разрешим сессии на порты 22 (SSH), 80 (HTTP) и 443 (HTTPS):

```
roman@roman-VirtualBox:~$ sudo ufw allow ssh
Rule added
Rule added (v6)
roman@roman-VirtualBox:~$ sudo ufw allow https
Rule added
Rule added (v6)
roman@roman-VirtualBox:~$ sudo ufw allow 80
Rule added
Rule added (v6)
roman@roman-VirtualBox:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere                  
443/tcp                    ALLOW       Anywhere                  
80                         ALLOW       Anywhere                  
22/tcp (v6)                ALLOW       Anywhere (v6)             
443/tcp (v6)               ALLOW       Anywhere (v6)             
80 (v6)                    ALLOW       Anywhere (v6) 
```

---

2. Процесс установки и выпуска сертификата с помощью hashicorp vault 

В отдельном терминале запустим сервер Vault:

```bash
roman@roman-VirtualBox:~$ vault server -dev -dev-root-token-id root
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.2
             Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf

==> Vault server started! Log data will stream in below:

2022-01-16T18:28:31.298+0300 [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no_proxy="\"\""
2022-01-16T18:28:31.298+0300 [WARN]  no `api_addr` value specified in config or in VAULT_API_ADDR; falling back to detection if possible, but this value should be manually set
2022-01-16T18:28:31.299+0300 [INFO]  core: Initializing VersionTimestamps for core
2022-01-16T18:28:31.299+0300 [INFO]  core: security barrier not initialized
2022-01-16T18:28:31.299+0300 [INFO]  core: security barrier initialized: stored=1 shares=1 threshold=1
2022-01-16T18:28:31.299+0300 [INFO]  core: post-unseal setup starting
2022-01-16T18:28:31.301+0300 [INFO]  core: loaded wrapping token key
2022-01-16T18:28:31.301+0300 [INFO]  core: Recorded vault version: vault version=1.9.2 upgrade time="2022-01-16 18:28:31.301875791 +0300 MSK m=+0.053064256"
2022-01-16T18:28:31.301+0300 [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
2022-01-16T18:28:31.301+0300 [INFO]  core: no mounts; adding default mount table
2022-01-16T18:28:31.303+0300 [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-01-16T18:28:31.303+0300 [INFO]  core: successfully mounted backend: type=system path=sys/
2022-01-16T18:28:31.304+0300 [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-01-16T18:28:31.306+0300 [INFO]  core: successfully enabled credential backend: type=token path=token/
2022-01-16T18:28:31.307+0300 [INFO]  rollback: starting rollback manager
2022-01-16T18:28:31.307+0300 [INFO]  core: restoring leases
2022-01-16T18:28:31.308+0300 [INFO]  expiration: lease restore complete
2022-01-16T18:28:31.308+0300 [INFO]  identity: entities restored
2022-01-16T18:28:31.308+0300 [INFO]  identity: groups restored
2022-01-16T18:28:31.309+0300 [INFO]  core: post-unseal setup complete
2022-01-16T18:28:31.309+0300 [INFO]  core: root token generated
2022-01-16T18:28:31.309+0300 [INFO]  core: pre-seal teardown starting
2022-01-16T18:28:31.309+0300 [INFO]  rollback: stopping rollback manager
2022-01-16T18:28:31.309+0300 [INFO]  core: pre-seal teardown complete
2022-01-16T18:28:31.309+0300 [WARN]  activity: could not load intent log: error="Vault is sealed"
2022-01-16T18:28:31.309+0300 [INFO]  core.cluster-listener.tcp: starting listener: listener_address=127.0.0.1:8201
2022-01-16T18:28:31.309+0300 [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=127.0.0.1:8201
2022-01-16T18:28:31.310+0300 [INFO]  core: post-unseal setup starting
2022-01-16T18:28:31.310+0300 [INFO]  core: loaded wrapping token key
2022-01-16T18:28:31.310+0300 [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
2022-01-16T18:28:31.311+0300 [WARN]  activity: could not list segments: error="context canceled"
2022-01-16T18:28:31.311+0300 [INFO]  core: successfully mounted backend: type=system path=sys/
2022-01-16T18:28:31.312+0300 [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-01-16T18:28:31.312+0300 [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-01-16T18:28:31.314+0300 [INFO]  core: successfully enabled credential backend: type=token path=token/
2022-01-16T18:28:31.314+0300 [INFO]  rollback: starting rollback manager
2022-01-16T18:28:31.314+0300 [INFO]  core: restoring leases
2022-01-16T18:28:31.314+0300 [INFO]  identity: entities restored
2022-01-16T18:28:31.314+0300 [INFO]  identity: groups restored
2022-01-16T18:28:31.314+0300 [INFO]  expiration: lease restore complete
2022-01-16T18:28:31.314+0300 [INFO]  core: post-unseal setup complete
2022-01-16T18:28:31.314+0300 [INFO]  core: vault is unsealed
2022-01-16T18:28:31.316+0300 [INFO]  expiration: revoked lease: lease_id=auth/token/root/hcbcb95d32d2c88e816631d9794d0b828e7c1c7faf49f3b681f6f3f74b380d388
2022-01-16T18:28:31.320+0300 [INFO]  core: successful mount: namespace="\"\"" path=secret/ type=kv
2022-01-16T18:28:31.330+0300 [INFO]  secrets.kv.kv_499e0486: collecting keys to upgrade
2022-01-16T18:28:31.331+0300 [INFO]  secrets.kv.kv_499e0486: done collecting keys: num_keys=1
2022-01-16T18:28:31.331+0300 [INFO]  secrets.kv.kv_499e0486: upgrading keys finished
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: kYkSq3CxFtRS+dx8lGp+DfohKq/0N61ePMRJsxJyisI=
Root Token: root

Development mode should NOT be used in production installations!
```

Сервер запускается на 8200 порте.

Добавим переменные окружения `VAULT_ADDR`, `VAULT_TOKEN`: 

```bash
roman@roman-VirtualBox:~$ export VAULT_ADDR=http://127.0.0.1:8200
roman@roman-VirtualBox:~$ export VAULT_TOKEN=root
```

Далее, создадим **Root CA** (Certificate Authority):

```bash
roman@roman-VirtualBox:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
roman@roman-VirtualBox:~$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
roman@roman-VirtualBox:~$ vault write -field=certificate pki/root/generate/internal common_name="example.com" ttl=87600h > CA_cert.crt
roman@roman-VirtualBox:~$ cat CA_cert.crt
-----BEGIN CERTIFICATE-----
MIIDNTCCAh2gAwIBAgIUF93Mx9B7iwI52WgkGvEh4CpAkEowDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjIwMTE2MTUzNjEwWhcNMzIw
MTE0MTUzNjM5WjAWMRQwEgYDVQQDEwtleGFtcGxlLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAKAGorfcZWaRjmvWO2O5TfkVcKe7SliKpgZg2LcT
PoTI+MgV0Ob/1eecgBs5DvL9bi6YESoZPko2JkQJZkgeH8b+3sW6yY1QfOL/ZXJV
pOp+yZypxCRc0lPy61kVPrDD0BnavbXZsEMKqp+vLq82/Anbnjki5Mg30No223Xb
mEA/Dn8zuS4qD3hBcbvLGVe4w5cvZTZnB+Ks/i2RC3JXoXJ4QX856O3KufHQJT7h
x44qwgko1JOIP1g8uvYUave9FrQLm4nPhzkbUIn0/GVTGHkFFaFfwCDHq5ts5YVn
nTXTxvx1/NDE3LTI9p4WK12rYaUrQfMga51AwKMMIYNxOpkCAwEAAaN7MHkwDgYD
VR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFMv5okgGNpBD
qyNG3dV9ah+Kw3lsMB8GA1UdIwQYMBaAFMv5okgGNpBDqyNG3dV9ah+Kw3lsMBYG
A1UdEQQPMA2CC2V4YW1wbGUuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQAzIJ7fKDla
pHzRmt5IdBaToEGt7AwgIU5x30GaHQzsrjHp1RPQhAQSNd+Uqa0av/ry9+c48fOP
ZvpfSt+vVST3JqOw7TXo7Zj9v3lcc+Uljd2uW6M9eXLqDaI0SUzmfPFTFVo7j1GA
PSNkmmGwBQl8JU7iffGQsyBueJmr7UY37W7KWl5BJ612UEfCdKIa8OpoXl/AeCrV
GDpddzReikk82sn71+cI+CqbfK/sBtCecvh5HslyoNRnIr7sHrTjRaYWL7rCqo6c
tvGd4pvaDwvXIuouPGjLGUoQi5izBzStWwvwbq2n6o/9rQ1plfDYdBcb3LEbQVtT
p7nreVEWw5fH
-----END CERTIFICATE-----
roman@roman-VirtualBox:~$ vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
```

**Root CA** создан.

Создадим **Intermediate CA**:

```bash
roman@roman-VirtualBox:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
roman@roman-VirtualBox:~$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
roman@roman-VirtualBox:~$ vault write -format=json pki_int/intermediate/generate/internal common_name="example.com Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
roman@roman-VirtualBox:~$ cat pki_intermediate.csr 
-----BEGIN CERTIFICATE REQUEST-----
MIICcjCCAVoCAQAwLTErMCkGA1UEAxMiZXhhbXBsZS5jb20gSW50ZXJtZWRpYXRl
IEF1dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPIeu4Q9
1W6r2ti/XDMmf3dkKsQXG2ObFiE9W9/4lJLxuOglBSMQqW7sBG0Shft+NyfWqbpg
VHolrbMkkNKfn91IvgFUoM/5MNUGy1liKkQjS2cENkXBua0xoYs6SIL7X4EKX8Zr
/lO9ITwG5t9bVaWlkFjJOUHZNwWpRlNYYvK53eAIJuxkzYbppsBAU5QV748BHftF
5+T/SI9drufDIJ55QTsiIXOI5RFXWsGQv07DWunBzf7gcWj3etyJ1i2+wUB1VcbF
/W5E0mlOidpdhmcceMy63hF4NhaHN7zNWpOYObov7PhA7P0HM4IZjs2/xbn4LM9V
aipm6ICPku/vhEUCAwEAAaAAMA0GCSqGSIb3DQEBCwUAA4IBAQByo1TS5Hlppkj0
n4dtgrHuqh5pI90WNw74JO3DhfnL2r/FfZTC3nRM24AJgN80pTlaPvHtv2kQpnuD
mQkH6/4Akg5X07yy7TbRWC2inLStYSzHu50KI3OwqVCcroKlcVRAQR3bW+6KVpF7
D9tPg1rcTpDreXIOfGYEG4spdLU0D7Mu40T/wRT8XUMOoqYLlXgsk+crpRgOi/r9
CXRWaAyDkNzcYOMbeylZGuc9EQBGu7Kcv6LQreCniolgd3WHs0EBtK9yNB69UvWW
LgTpi0TMP6832se9wiMutfLXCf2djPZqetO6rjT6DSqKFYGpo3F+oin0iflJL9Nf
p8Tbgs8/
-----END CERTIFICATE REQUEST-----
roman@roman-VirtualBox:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem
roman@roman-VirtualBox:~$ cat intermediate.cert.pem 
-----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIUNHa4uFDklUBLPGSp6z7tp/48PmgwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjIwMTE2MTU0MjAwWhcNMjcw
MTE1MTU0MjMwWjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8h67hD3V
bqva2L9cMyZ/d2QqxBcbY5sWIT1b3/iUkvG46CUFIxCpbuwEbRKF+343J9apumBU
eiWtsySQ0p+f3Ui+AVSgz/kw1QbLWWIqRCNLZwQ2RcG5rTGhizpIgvtfgQpfxmv+
U70hPAbm31tVpaWQWMk5Qdk3BalGU1hi8rnd4Agm7GTNhummwEBTlBXvjwEd+0Xn
5P9Ij12u58MgnnlBOyIhc4jlEVdawZC/TsNa6cHN/uBxaPd63InWLb7BQHVVxsX9
bkTSaU6J2l2GZxx4zLreEXg2Foc3vM1ak5g5ui/s+EDs/QczghmOzb/Fufgsz1Vq
KmbogI+S7++ERQIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBSgVJthF30mj1vUmy0oaDqZNBpa4zAfBgNVHSMEGDAW
gBTL+aJIBjaQQ6sjRt3VfWofisN5bDA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
AQELBQADggEBADEmTTeJfX0ZHYGISLULjLORhUUzx4uOOu9K+NOKyN5flsa24b4Y
EvQjMN9yZ/3DokDYQcl2enzOMcmp5Go0eZk/V/tACbJALvKV6PEOY+SQ46GA5eP8
kv6hxovEbKLrT5qltbzTSL5IDh8Gs7Zim7OSbKCR9Mu26La3HL7ikggt0Opn5st7
Wu2VgNqLC2SlGnDXSOSKbAQrgKMQuBR8PrqjmxNmlGFdPKxv6I8XqoB7Eqj7C9uZ
JQbp/tNCPrQvdfAoS5lUpqBxO3nCKU1HZE+ICFlCCuFpM0oscQ+8rwkcG5tpu0kF
QOzLrR1Ynz95YMeSf0cOgjfaIeMw8rpO1LY=
-----END CERTIFICATE-----
roman@roman-VirtualBox:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```

Создадим **роль**. При создании роли необходимо указать параметр `allow_bare_domains` равным `true`:

```bash
roman@roman-VirtualBox:~$ vault write pki_int/roles/example-dot-com allowed_domains="example.com" allow_bare_domains=true allow_subdomains=true max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
```

Выпустим **идентификационный сертификат**:

```bash
roman@roman-VirtualBox:~$ vault write pki_int/issue/example-dot-com common_name="example.com" ttl="720h" > example.com.crt
roman@roman-VirtualBox:~$ cat example.com.crt 
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIUNHa4uFDklUBLPGSp6z7tp/48PmgwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjIwMTE2MTU0MjAwWhcNMjcw
MTE1MTU0MjMwWjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8h67hD3V
bqva2L9cMyZ/d2QqxBcbY5sWIT1b3/iUkvG46CUFIxCpbuwEbRKF+343J9apumBU
eiWtsySQ0p+f3Ui+AVSgz/kw1QbLWWIqRCNLZwQ2RcG5rTGhizpIgvtfgQpfxmv+
U70hPAbm31tVpaWQWMk5Qdk3BalGU1hi8rnd4Agm7GTNhummwEBTlBXvjwEd+0Xn
5P9Ij12u58MgnnlBOyIhc4jlEVdawZC/TsNa6cHN/uBxaPd63InWLb7BQHVVxsX9
bkTSaU6J2l2GZxx4zLreEXg2Foc3vM1ak5g5ui/s+EDs/QczghmOzb/Fufgsz1Vq
KmbogI+S7++ERQIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBSgVJthF30mj1vUmy0oaDqZNBpa4zAfBgNVHSMEGDAW
gBTL+aJIBjaQQ6sjRt3VfWofisN5bDA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
AQELBQADggEBADEmTTeJfX0ZHYGISLULjLORhUUzx4uOOu9K+NOKyN5flsa24b4Y
EvQjMN9yZ/3DokDYQcl2enzOMcmp5Go0eZk/V/tACbJALvKV6PEOY+SQ46GA5eP8
kv6hxovEbKLrT5qltbzTSL5IDh8Gs7Zim7OSbKCR9Mu26La3HL7ikggt0Opn5st7
Wu2VgNqLC2SlGnDXSOSKbAQrgKMQuBR8PrqjmxNmlGFdPKxv6I8XqoB7Eqj7C9uZ
JQbp/tNCPrQvdfAoS5lUpqBxO3nCKU1HZE+ICFlCCuFpM0oscQ+8rwkcG5tpu0kF
QOzLrR1Ynz95YMeSf0cOgjfaIeMw8rpO1LY=
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDXDCCAkSgAwIBAgIUH+mjxTo9VfLmN4raDKNQoEi2/PYwDQYJKoZIhvcNAQEL
BQAwLTErMCkGA1UEAxMiZXhhbXBsZS5jb20gSW50ZXJtZWRpYXRlIEF1dGhvcml0
eTAeFw0yMjAxMTYxNTUxMTdaFw0yMjAyMTUxNTUxNDdaMBYxFDASBgNVBAMTC2V4
YW1wbGUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzpO7Nj6S
pGcxnQ4mynsfWya2pcmWal1gbW4SrjLoO/sqMIi0bchwTVaj9yYzHU8BqbA1TKLg
/DwZNov9H4G933iqTLs9mGVptMhoDK7Jp9JNYoXu/VLDjY1KoNwPwFQhlRPGJiZZ
mDxlFXcFIve34EuwhfU0gX8k1XyGxfsoDpf6onaRbHPpk9+jJEtGAeKKrm2i4evw
I5xrM2uUBwTmqeqxBbb4TLsj9G63ZIdVvQjihlZSXv/i/dc/JoEqIkb8J2t1Nf5A
7FwzyzhslpFsEXT6oSJCFq3GimSnt0zxAGw9VrNiQORkUDFs9X73UlEq3XnGnHlW
HGyWsM70k8AcRQIDAQABo4GKMIGHMA4GA1UdDwEB/wQEAwIDqDAdBgNVHSUEFjAU
BggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFDQN+lN746o9twsY5leDz0N4
lOF4MB8GA1UdIwQYMBaAFKBUm2EXfSaPW9SbLShoOpk0GlrjMBYGA1UdEQQPMA2C
C2V4YW1wbGUuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQBQohsxiJCBei/vXkPeMSVM
PmcMS501TOSa3ISOj89ZyAZydbLF+c0rpJhF16LaVncOQHVCHj/eQ9sMU1dOTdhj
aHdZFDp803v4cPNKHYIh5nXlbJM8fmbK7CBb/0JOV9si2YKvomJdd7ovhTgUUFxW
0N4zBiMYEQgMVK1r8wFAi29ZrWpQyh6NM6AYa2zY2zmp0bWdXsyBdOXGbr79G4hX
Wa163VZc1EB4ptwQ2o6n2kt0sD3VpJk7/xb30ll5y+5nAtkHxiHaASnrq6kZ/bXT
peVjoDQYGO9zQMLObOIcfWgv5tJpa2sMgexLNJOyp0M9sFFRyOS5ApAyBBWgh4xN
-----END CERTIFICATE-----
expiration          1644940307
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIUNHa4uFDklUBLPGSp6z7tp/48PmgwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjIwMTE2MTU0MjAwWhcNMjcw
MTE1MTU0MjMwWjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8h67hD3V
bqva2L9cMyZ/d2QqxBcbY5sWIT1b3/iUkvG46CUFIxCpbuwEbRKF+343J9apumBU
eiWtsySQ0p+f3Ui+AVSgz/kw1QbLWWIqRCNLZwQ2RcG5rTGhizpIgvtfgQpfxmv+
U70hPAbm31tVpaWQWMk5Qdk3BalGU1hi8rnd4Agm7GTNhummwEBTlBXvjwEd+0Xn
5P9Ij12u58MgnnlBOyIhc4jlEVdawZC/TsNa6cHN/uBxaPd63InWLb7BQHVVxsX9
bkTSaU6J2l2GZxx4zLreEXg2Foc3vM1ak5g5ui/s+EDs/QczghmOzb/Fufgsz1Vq
KmbogI+S7++ERQIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBSgVJthF30mj1vUmy0oaDqZNBpa4zAfBgNVHSMEGDAW
gBTL+aJIBjaQQ6sjRt3VfWofisN5bDA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
AQELBQADggEBADEmTTeJfX0ZHYGISLULjLORhUUzx4uOOu9K+NOKyN5flsa24b4Y
EvQjMN9yZ/3DokDYQcl2enzOMcmp5Go0eZk/V/tACbJALvKV6PEOY+SQ46GA5eP8
kv6hxovEbKLrT5qltbzTSL5IDh8Gs7Zim7OSbKCR9Mu26La3HL7ikggt0Opn5st7
Wu2VgNqLC2SlGnDXSOSKbAQrgKMQuBR8PrqjmxNmlGFdPKxv6I8XqoB7Eqj7C9uZ
JQbp/tNCPrQvdfAoS5lUpqBxO3nCKU1HZE+ICFlCCuFpM0oscQ+8rwkcG5tpu0kF
QOzLrR1Ynz95YMeSf0cOgjfaIeMw8rpO1LY=
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzpO7Nj6SpGcxnQ4mynsfWya2pcmWal1gbW4SrjLoO/sqMIi0
bchwTVaj9yYzHU8BqbA1TKLg/DwZNov9H4G933iqTLs9mGVptMhoDK7Jp9JNYoXu
/VLDjY1KoNwPwFQhlRPGJiZZmDxlFXcFIve34EuwhfU0gX8k1XyGxfsoDpf6onaR
bHPpk9+jJEtGAeKKrm2i4evwI5xrM2uUBwTmqeqxBbb4TLsj9G63ZIdVvQjihlZS
Xv/i/dc/JoEqIkb8J2t1Nf5A7FwzyzhslpFsEXT6oSJCFq3GimSnt0zxAGw9VrNi
QORkUDFs9X73UlEq3XnGnHlWHGyWsM70k8AcRQIDAQABAoIBADviC2UgInZSC8nR
bmFH68EKqevJUjcnNmrCe9vPmg65MnO7TUJ91kA1G3brtemLG5pLIEhE9x9ndI+h
aREXFSmQ2x0/Mg3ZaBkl9zOl/4MMra4f0TXSJioEiVu0L0S7nriOcORiPZqp90uP
oweN89mrV1Kd0EixyMWyQYdm1SfVVOfZoKke6r3kq1cQOsIBW4lL1QfXfQ6t8giH
S2TSbC0QLyL+I6RLRUUYyvuhd5PdkLgSKH3Kmets1NyXMYkhiQ+/62B+uqRNsA5O
a+1hyAoHPNzYHkmcksBfuL3Ny6zIWkdTiJeLAJ4wB4wVVhhIY1VdV3hQqbqKeAwv
SYjK9sECgYEA+XEyMpu2q6pLeMYN96cIF685bPFChs5OMKWGmbzIZ/YANgdWTH2W
kXrEI7ZSrQsC7HzFQw8D6oPwPCg7ymGKBNN5suqzsWUbM29SjhprSQ3E5YYRqJc7
wYNZRg08p3ivPveouXePKh0eIly/fAwWIhOGrDcJFYTA5+8zR1ydkNkCgYEA1AIL
Clfmc1gAb09zGeEy0zot9C+cRkuyorXe41Or3d7zWCh7zSrsR3DhNDCxSZH2zqQd
P0jT5kjQ4bewCo8U2SBZNKNj2gE54bd34dRVfv9+SxziXWAlBJxJz2KOt7jJicMV
VSwjSVRZoo+E468/wXthc/TWt2ZSeDNEHoNRA00CgYEAm6+S7RNTCAHZ6R90SEXw
PxgWd3B9XTYWhzZItFunmXto1k/uBP+9oj9FfCSnpWliAcg+NoSApTaEEofqCX6n
biuvoYPrc6TvPUMV+6txmr8FTVxIWTlLCpS4e4h3eu9QMbTRkjCVImvaCwhoWzwP
9GTLgWE4Qj4BSMF69+dOUMECgYEAyOzSx8+8oW4yo0uZ21oZkCSgbr88jUaqmxhg
j/O5e8ITwGZFxpE6cw6g8JSBQSdr0DWrXlHIOYSjKnirB6bI7GqDAKclN/RXhfsa
S9Wv3XeImulaA4LeMntoXHqcpbQklUJlEl6NZq7hcHYyTJLHirhDCOFvKUt5N1/m
3EA55DUCgYBWXCJ0Ja9m7TZYdTRemQ3vm3XZovJIvYneWGRUQbgwUg/3RMOXzzA8
1QtAhJkgwyHx3iWMjUI0tSV3peNq0oP8CG3ZHtnteFUziK8NJbzF1gCBst/PXDm4
rYgHfQn2FOKmuQUUnbNNHpnHse/Vsn2qJBFEE5o5WVkKnNGhXqJQoQ==
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       1f:e9:a3:c5:3a:3d:55:f2:e6:37:8a:da:0c:a3:50:a0:48:b6:fc:f6
```

Скопируем корневой сертификат в shared folder, и установим его на хостовой машине (macOS Big Sur):

![Certificate-keychain](img/certificate-keychain.png)

<img src="img/certificate-keychain.png" data-canonical-src="img/certificate-keychain.png" width="200" align="center"/>

---

3. Процесс установки и настройки сервера nginx 

Установка `nginx`:

```bash
sudo apt-get install nginx
...
Setting up nginx-core (1.18.0-0ubuntu1.2) ...
Setting up nginx (1.18.0-0ubuntu1.2) ...
...
```

Настройка `nginx`. 

Для работы с `nginx` выключим ранее настроенный `apache2`:

```bash
roman@roman-VirtualBox:~$ sudo systemctl stop apache2
roman@roman-VirtualBox:~$ sudo systemctl disable apache2
Synchronizing state of apache2.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable apache2
Removed /etc/systemd/system/multi-user.target.wants/apache2.service.
```

Создадим новую страницу:

```bash
roman@roman-VirtualBox:~$ sudo mkdir -p /var/www/example.com/html
roman@roman-VirtualBox:~$ sudo chown -R $USER:$USER /var/www/example.com/html
roman@roman-VirtualBox:~$ sudo chmod -R 755 /var/www/example.com
roman@roman-VirtualBox:~$ nano /var/www/example.com/html/index.html
<html>
	<head>
		<title>pcs-devsys-diplom</title>
	</head>
	<body>
		<h1>This is <b>pcs-devsys-diplom</b> exam's test page</h1>
	</body>
</html>
```

Настроим доступ страницу в `nginx`: 

```bash
roman@roman-VirtualBox:~$ sudo nano /etc/nginx/sites-available/example.com.conf
server {
        listen 127.0.0.1:80;
        listen 127.0.0.1:443 ssl http2;

        ssl_certificate /home/roman/Documents/example.com.crt.pem;
        ssl_certificate_key /home/roman/Documents/example.com.crt.key;

        server_name example.com www.example.com;
        root /var/www/example.com/html;
        index index.html;

        location / {
                try_files $uri $uri/ =404;
        }
}
roman@roman-VirtualBox:~$ sudo ln -s /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-enabled/example.com.conf
```

Добавим адрес в `/etc/hosts`:

```bash
roman@roman-VirtualBox:~$ sudo nano /etc/hosts
127.0.0.1       example.com
```

Запустим `nginx`:

```bash
roman@roman-VirtualBox:~$ sudo systemctl start nginx
roman@roman-VirtualBox:~$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset:>
     Active: active (running) since Sun 2022-01-16 19:16:42 MSK; 15min ago
       Docs: man:nginx(8)
   Main PID: 3462 (nginx)
      Tasks: 5 (limit: 4637)
     Memory: 5.1M
     CGroup: /system.slice/nginx.service
             ├─3462 nginx: master process /usr/sbin/nginx -g daemon on; master_>
             ├─3463 nginx: worker process
             ├─3464 nginx: worker process
             ├─3465 nginx: worker process
             └─3466 nginx: worker process

янв 16 19:16:42 roman-VirtualBox systemd[1]: Starting A high performance web se>
янв 16 19:16:42 roman-VirtualBox systemd[1]: Started A high performance web ser>
lines 1-16/16 (END)
```

Зайдем по адресу `http://example.com` и `https://example.com` в виртуальной машине:

![Example-com-vm](img/example-com-vm.png)

---

4. Страница сервера nginx в браузере хоста не содержит предупреждений 

Страница example.com в Safari (на хосте):

![Certificate-host](img/certificate-host.png)

---

5. Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")

Скрипт генерации сертификата:

```sh
date
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

# Removing expired certificates
if vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true
then
  echo -e "\033[1mSuccessfully revoked expired certificates!\033[0m"
else
  echo -e "\033[1mSomething's wrong. Didn't manage to revoke expired certificates.\033[0m"
fi

# Generating a new certificate
if vault write -format=json pki_int/issue/example-dot-com common_name="example.com" ttl="720h" > example.com.crt
then
  echo -e "\033[1mSuccessfully generated a new certificate!\033[0m"
else
  echo -e "\033[1mSomething's wrong. Didn't manage to generate a new certificate. Interrupting the script...\033[0m"
  exit
fi
jq -r .data.certificate < example.com.crt > /home/roman/Documents/example.com.crt.pem
jq -r .data.issuing_ca < example.com.crt >> /home/roman/Documents/example.com.crt.pem
jq -r .data.private_key < example.com.crt > /home/roman/Documents/example.com.crt.key

# Check
if nginx -t
then
    echo -e "\033[1mRestarting nginx...\033[0m"
    if systemctl restart nginx
    then
      echo -e "\033[1mRestarted nginx successfully.\033[0m"
    else
      echo -e "\033[1m[!!!] Something's wrong. Please check it manually.\033[0m"
    fi
else
    echo -e "\033[1m[!!!] Something's wrong. Please check it manually.\033[0m"
fi
```

Запустим скрипт и проверим статус `nginx`: 

```bash
roman@roman-VirtualBox:~/Documents$ sudo ./renew.sh 
Пн 17 янв 2022 18:36:35 MSK
Starting renew-certs.sh...
WARNING! The following warnings were returned from Vault:

  * Tidy operation successfully started. Any information from the operation
  will be printed to Vault's server logs.

Successfully revoked expired certificates!
Successfully generated a new certificate!
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
Restarting nginx...
Restarted nginx successfully.
roman@roman-VirtualBox:~/Documents$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-01-17 18:36:35 MSK; 4s ago
       Docs: man:nginx(8)
    Process: 4029 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=>
    Process: 4031 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 4034 (nginx)
      Tasks: 5 (limit: 4637)
     Memory: 4.5M
     CGroup: /system.slice/nginx.service
             ├─4034 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─4035 nginx: worker process
             ├─4036 nginx: worker process
             ├─4037 nginx: worker process
             └─4038 nginx: worker process

янв 17 18:36:35 roman-VirtualBox systemd[1]: Starting A high performance web server and a reverse proxy ser>
янв 17 18:36:35 roman-VirtualBox systemd[1]: Started A high performance web server and a reverse proxy serv>
```

---

6. Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)

Для проверки работы скрипта в `crontab` установим время запуска каждые 2 минуты:

```bash
roman@roman-VirtualBox:~$ sudo crontab -l
*/2 * * * * /home/roman/Documents/renew.sh
```

С разницой в 2 минуты обновим страницу example.com:

* 2022-01-17 18:54:01 MSK

![Certificate-host](img/certificate-cron-1.png)

* 2022-01-17 18:56:01 MSK

![Certificate-host](img/certificate-cron-2.png)