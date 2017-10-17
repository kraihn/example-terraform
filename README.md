# example-terraform

```yaml
variables:
  - GIT_COMMIT_REF
  - BACKEND_AWS_BUCKET
  - BACKEND_AWS_KEY
  - BACKEND_AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_DEFAULT_REGION
  - CLOUDFLARE_EMAIL
  - CLOUDFLARE_TOKEN
  - AWS_PUBLIC_KEY
  - DOKKU_DOMAIN
  - DOKKU_SUBDOMAIN_TEST_SUFFIX
 
stages:
  - build
  - review
  - cleanup
 
build:
  stage: build
  script:
    - git checkout master
    - terraform init
    - terraform get
    - terraform plan -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN" -var "dokku_subdomain_test_suffix=$DOKKU_SUBDOMAIN_TEST_SUFFIX"
    - terraform apply -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN" -var "dokku_subdomain_test_suffix=$DOKKU_SUBDOMAIN_TEST_SUFFIX"
  artifacts:
    paths:
      - terraform.tfstate
  except:
    - master
 
review:
  stage: review
  script:
    - git checkout $GIT_COMMIT_REF
    - terraform get
    - terraform plan -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN" -var "dokku_subdomain_test_suffix=$DOKKU_SUBDOMAIN_TEST_SUFFIX"
    - terraform apply -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN" -var "dokku_subdomain_test_suffix=$DOKKU_SUBDOMAIN_TEST_SUFFIX"
  when: on_success
  dependencies:
    - build
  artifacts:
    paths:
      - terraform.tfstate
  except:
    - master
 
production:
  stage: build
  script:
    - echo 'terraform { backend "s3" {}}' >> main.tf
    - terraform init -backend-config="bucket=$BACKEND_AWS_BUCKET" -backend-config="key=$BACKEND_AWS_KEY" -backend-config="region=$BACKEND_AWS_REGION"
    - terraform get
    - terraform refresh -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN"
    - terraform plan -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN"
    - terraform apply -var "aws_public_key=$AWS_PUBLIC_KEY" -var "dokku_domain=$DOKKU_DOMAIN"
  only:
    - master
 
cleanup_build:
  stage: review
  script:
    - terraform destroy -force
  when: on_failure
  dependencies:
    - build
  artifacts:
    paths:
      - terraform.tfstate
  except:
    - master
 
cleanup_review:
  stage: cleanup
  script:
    - terraform destroy -force
  when: always
  dependencies:
    - review
  except:
    - master
```