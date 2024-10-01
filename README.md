# Projeto Lambda Authorization Terraform

Este projeto utiliza Terraform para provisionar uma fun��o Lambda na AWS, incluindo a cria��o de uma role IAM necess�ria para a execu��o da fun��o.

## Estrutura do Projeto

- `main.tf`: Arquivo principal contendo a defini��o dos recursos do Terraform.
- `.github/workflows/`: Cont�m os workflows do GitHub Actions para CI/CD.

## Vari�veis

As seguintes vari�veis s�o utilizadas no `main.tf`:

- `environment`: O ambiente para deploy (dev ou prod).

## Workflows do GitHub Actions

### `terraform-merge-prod.yml`

Este workflow � acionado em pushs para a branch `main` e aplica as mudan�as no ambiente de produ��o.

### `terraform-merge-dev.yml`

Este workflow � acionado em pushs para a branch `dev` e aplica as mudan�as no ambiente de desenvolvimento.

### `terraform-checks.yml`

Este workflow � acionado em pull requests para as branches `dev` e `main` e realiza verifica��es de formata��o, inicializa��o, valida��o e plano do Terraform.

## Vari�veis de Ambiente no GitHub Actions

As seguintes vari�veis de ambiente podem ser configuradas no GitHub Actions:

Para acesso � AWS:
- `AWS_ACCESS_KEY_ID`: Chave de acesso da AWS (definir em secrets).
- `AWS_SECRET_ACCESS_KEY`: Chave secreta da AWS (definir em secrets).

Configura��es para ambiente de desenvolvimento (dev):
- `ENVIRONMENT_DEV`: Ambiente de desenvolvimento (definir em secrets).

Configura��es para ambiente de produ��o (prod):
- `ENVIRONMENT_PROD`: Ambiente de produ��o (definir em secrets).

## Como Usar

1. Clone o reposit�rio:
    ```sh
    git clone https://github.com/grupo57/lambda_authorization_terraform
    cd lambda_authorization_terraform
    ```

2. Configure as vari�veis de ambiente necess�rias:
    ```sh
    export AWS_ACCESS_KEY_ID=your_access_key_id
    export AWS_SECRET_ACCESS_KEY=your_secret_access_key
    export AWS_DEFAULT_REGION=your_default_region
    export TF_VAR_environment=your_environment
    ```

3. Inicialize o Terraform:
    ```sh
    terraform init
    ```

4. Selecione o workspace apropriado:
    ```sh
    terraform workspace select dev || terraform workspace new dev
    ```
   ou
    ```sh
    terraform workspace select main || terraform workspace new main
    ```

5. Aplique as mudan�as:
    ```sh
    terraform apply -auto-approve
    ```

## Licen�a

Este projeto est� licenciado sob a licen�a MIT. Veja o arquivo `LICENSE` para mais detalhes.