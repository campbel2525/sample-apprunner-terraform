# info

next.js を AWS App Runner で公開する Terraform のコードになります

# インフラ構成図

![インフラ構成図](https://github.com/campbel2525/sample-apprunner-terraform/blob/main/docs/%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E6%A7%8B%E6%88%90%E5%9B%B3/%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E6%A7%8B%E6%88%90%E5%9B%B3.png?raw=true)

# 環境設定、apply

1. `credentials/aws/config.example`を参考にして`credentials/aws/config`を作成

2. `make init`

# apply 方法(stg 環境の例)

1. `src/project/backend-config.env-kind.hcl.example`を参考にして`src/project/backend-config.env-kind.hcl`を作成

2. `src/project/terraform.env-kind.tfvars.example`を参考にして`src/project/terraform.env-kind.tfvars`を作成

3. `make shell`

   ここから下は docker 内で行われる

4. `cd /project/project`

5. sso でログインを行う

   `sl`

6. `make stg-apply`

   削除する場合: `make stg-destroy`

# コマンド

## github の finger print を取得するコマンド。

環境変数に設置する際には大文字を小文字に変換すること

```
openssl s_client -connect token.actions.githubusercontent.com:443 -showcerts \
 </dev/null 2>/dev/null \
 | openssl x509 -noout -fingerprint -sha1 \
 | sed 's/://g' | sed 's/SHA1 Fingerprint=//'
```

# Tips

## 1

App Runner を apply する際にデプロイが必ず走ります。デプロイを走らないようにするのは不可能です。

そのためインフラの構築は

1. Ecr を作成

   (例) `terraform apply -auto-approve -target=module.user_front_apprunner.aws_ecr_repository.app -var-file=../terraform.stg.tfvars`

   push の具体的な処理は`push_initial_image.sh`に書いてあります。

2. AWS にあるサンプル image を push

   (例) `./push_initial_image.sh aws-stg ap-northeast-1 user-front-repo`

3. App Runner を apply

   (例) `terraform apply -auto-approve -var-file=../terraform.stg.tfvars`

という流れになっています。

`src/project/Makefile`の`stg-apply`を参照
