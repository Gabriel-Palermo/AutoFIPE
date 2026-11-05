# AutoFIPE 🚗

Aplicativo desenvolvido em Flutter para consulta de informações e preços de veículos por meio da Tabela FIPE, utilizando a API da Invertexto.

## Sobre o projeto

O AutoFIPE permite consultar marcas, modelos, anos e preços de veículos, além de visualizar o histórico de preços de determinado veículo.

O projeto foi desenvolvido como atividade acadêmica do curso de Engenharia de Software.

## Funcionalidades

- Listagem de marcas de veículos.
- Pesquisa de marcas.
- Listagem de modelos de uma marca.
- Pesquisa de modelos.
- Consulta de anos e preços atuais.
- Visualização do histórico de preços.
- Interface escura com identidade visual automotiva e tecnológica.

## Tecnologias utilizadas

- Flutter
- Dart
- API REST
- HTTP

## API utilizada

**Invertexto – Tabela FIPE**

Documentação: https://api.invertexto.com/

Endereço da API: https://api.invertexto.com/v1/fipe

A aplicação utiliza a API para obter os dados de marcas, modelos, anos e histórico de preços dos veículos.

## Como executar o projeto

1. Instale o Flutter e configure o ambiente de desenvolvimento.
2. Clone este repositório:

   ```bash
   git clone https://github.com/Gabriel-Palermo/AutoFIPE.git
   ```

3. Entre na pasta:

   ```bash
   cd AutoFIPE
   ```

4. Instale as dependências:

   ```bash
   flutter pub get
   ```

5. Configure o token de acesso da API da Invertexto.
6. Execute no navegador Chrome:

   ```bash
   flutter run -d chrome
   ```

## Desenvolvedor

Gabriel Palermo

Projeto acadêmico – Engenharia de Software.
