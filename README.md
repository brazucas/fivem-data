# REPOSITÓRIO ARQUIVADO
**O servidor agora está sendo desenvolvido com código-fonte fechado, este repositório foi arquivado e permancerá disponível apenas como histórico.**



================================================




[![Discord](https://img.shields.io/discord/591914197219016707.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/BAZ5aCU)

# Servidor para GTA V do Brazuca's utilizando o mod FiveM.

##### Posso entrar no time de testes?

Faça uma solicitação em nosso Discord.

##### Posso entrar no time de desenvolvimento?

Claro! o projeto é de código aberto e qualquer um pode contribuir, basta fazer um fork e pull requests.

# Pré-Requisitos

1. Tenha acesso a uma máquina Windows.

   > Atualmente o FXServer roda de forma estável apenas no Windows.

2. Gere uma [Steam API Key](https://steamcommunity.com/dev/apikey).

3. Faça download do [FXServer](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/).

4. Crie uma chave de servidor no [FiveM Keymaster](https://keymaster.fivem.net).

5. Faça download e instale o [MongoDB](https://www.mongodb.com/try/download/community?tck=docs_server).
    - Faça a instalação padrão.

6. Instale o [NodeJS](https://nodejs.org/en/download/).

7. (Opcional) Instale o [Yarn](https://classic.yarnpkg.com/en/docs/install).

# Configurando o banco de dados MongoDB

1. Felizmente o MongoDB não necessita que a estrutura de collections esteja criada para funcionar, então nenhuma
   configuração a mais é necessária
2. Execute o comando `npm install` ou `yarn install` na pasta `resources/mongodb`.

# Configurando o projeto

1. Descompacte a pasta do FXServer baixado.
2. Copie a pasta do projeto para dentro da pasta descompactada, de forma que a estrutura fique da seguinte maneira:

<img src="https://cdn.brz.gg/fivem-data/instalacao_servidor_1.png" width="300px"/>

> O conteúdo deste projeto fica dentro da pasta `fivem-data` dentro da pasta descompactada do `FXServer`.

3. Copie o arquivo `config/config.cfg.dist` para `config/config.cfg`
4. Copie o arquivo `config/keys.cfg.dist` para `config/keys.cfg`
5. Copie o arquivo `config/database.cfg.dist` para `config/database.cfg`
6. Coloque a chave da Steam API na variável `steam_webApiKey` no arquivo `config/keys.cfg`
7. Coloque a chave do servidor gerado no FiveM Keymaster na variável `sv_licenseKey` no arquivo `config/keys.cfg`.
8. Configure o arquivo `config/config.cfg` da forma que preferir, ou deixe os valores padrão.
9. Configure o arquivo `config/database.cfg` ajustando as variáveis de acordo com a configuração feita para o seu banco
   de dados. Se você tiver feito a instalação padrão (sem senha), nenhuma ação é necessária.

# Recurso [maps]

Como os mapas customizados do servidor possuem arquivos muito grandes, é necessário baixá-los a parte. Faça download do
resource [maps] [em nosso CDN](https://cdn.brz.gg/fivem-data/%5Bmap%5D.zip). Em seguida descompacte o arquivo dentro da
pasta `resources`, de forma que a estruture fique da seguinte maneira: `resources/[maps]/zirix_maps`

# Recurso [brz]

Apesar de modificarmos o `vRP` para adaptar a nossa proposta do Brazucas, sistemas novos feitos pela equipe estão sendo
feitos em um recurso a parte, chamado de `[brz]`.

# Código NUI do Brazucas

Toda a parte client-side do NUI do servidor está em um projeto específico, chamado
de [fivem-client](https://github.com/brazucas/fivem-client). Caso você não esteja contribuindo para o projeto, não
precisa fazer nada, pois os arquivos de build do projeto já estão comitados em `resources/[brz]/brz_bui/nui`

# Abrindo o servidor local

1. Execute o arquivo `FXServer.exe`.
2. Após autenticar em sua conta do `Citizen`, aguarde a inicialização do servidor.
3. Acesse o endereço http://localhost:40120 e faça a autenticação.
4. No menu lateral esquerdo, acesse a aba `Settings` > `FXServer`.
5. Configure corretamente o campo `Server Data Folder`
5. Configure corretamente o campo `CFG File Path`
5. Coloque o seguinte valor no campo `Additional Arguments`:
   > +set onesync on +set onesync_population false
7. Na opção `OneSync`, selecione `On (with infinity)`
8. Acesse a aba `Dashboard` e clique na opção `Restart` para reiniciar o servidor.

Agora é só fazer a sua contribuição para o Brazucas!
