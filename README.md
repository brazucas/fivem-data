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

5. Faça download e instale o [MySQL Server](https://dev.mysql.com/downloads/installer/).
    - Faça a instalação padrão.
    - Lembre-se de copiar a senha do usuário root criado.

# Configurando o banco de dados MySQL

1. Abra o MySQL Workbench e conecte-se ao banco de dados.
2. Crie um novo schema/database chamado `brz`.
3. Copie o conteúdo do arquivo `brz.sql` para a janela de `Query` do MySQL Workbeach, selecione tudo e em seguida
   execute todas as instruções.
4. Clique em aplicar alterações.

# Configurando o projeto

1. Descompacte a pasta do FXServer baixado.
2. Copie a pasta do projeto para dentro da pasta descompactada, de forma que a estrutura fique da seguinte maneira:

<img src="https://cdn.brz.gg/fivem-data/instalacao_servidor_1.png" width="300px"/>

> O conteúdo deste projeto fica dentro da pasta `fivem-data` dentro da pasta descompactada do `FXServer`.

3. Copie o arquivo `config/config.cfg.dist` para `config/config.cfg`
4. Copie o arquivo `config/keys.cfg.dist` para `config/keys.cfg`
5. Copie o arquivo `resources/GHMattiMySQL/settings.xml.dist` para `resources/GHMattiMySQL/settings.xml`
6. Coloque a chave da Steam API na variável `steam_webApiKey` no arquivo `config/keys.cfg`
7. Coloque a chave do servidor gerado no FiveM Keymaster na variável `sv_licenseKey` no arquivo `config/keys.cfg`.
8. Configure o arquivo `config/config.cfg` da forma que preferir, ou deixe os valores padrão.
9. Configure o arquivo `resources/GHMattiMySQL/settings.xml` ajustando as variáveis de acordo com a configuração feita
   para o seu banco de dados.

# Recurso [maps]

Como os mapas customizados do servidor possuem arquivos muito grandes, é necessário baixá-los a parte. Faça download do
resource [maps] [em nosso CDN](https://cdn.brz.gg/fivem-data/%5Bmap%5D.zip). Em seguida descompacte o arquivo dentro da
pasta `resources`, de forma que a estruture fique da seguinte maneira: `resources/[maps]/zirix_maps`

# Código NUI do Brazucas

Toda a parte client-side do NUI do servidor está em um projeto específico, chamado de [fivem-client](https://github.com/brazucas/fivem-client). Caso você não esteja contribuindo para o projeto, não precisa fazer nada, pois os arquivos de build do projeto já estão comitados em `resources/[nui]/browser/html`

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
