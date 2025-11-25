# Documentação do Projeto: 4Tech WebUI

## 1. Visão Geral do Projeto

O **4Tech WebUI** é uma aplicação desktop e web desenvolvida em Flutter que serve como uma interface de usuário (UI) para interagir com a ferramenta [Ollama](https://ollama.ai/). A aplicação permite que os usuários conversem com modelos de linguagem (LLMs) executados localmente, gerenciem esses modelos (baixando ou excluindo) e também gerenciem anotações pessoais.

As principais funcionalidades são:
- **Chat:** Interface de conversação em tempo real com qualquer modelo Ollama disponível.
- **Gerenciamento de Modelos:** Lista, baixa e remove modelos de LLM da biblioteca local do Ollama.
- **Anotações:** Um editor de texto simples para criar e salvar anotações localmente.
- **Configurações:** Permite alternar entre temas claro e escuro e configurar o endereço da API do Ollama.

## 2. Arquitetura

O projeto utiliza uma arquitetura em camadas, promovendo uma clara separação de responsabilidades. O padrão de gerenciamento de estado adotado é o **Provider**, que permite a comunicação entre a UI e a lógica de negócio de forma desacoplada.

As principais camadas são:
- **UI (Telas):** Localizada em `lib/screens`, é responsável por exibir os dados e capturar as interações do usuário.
- **State Management (Providers):** Localizada em `lib/providers`, contém a lógica de negócio e o estado da aplicação. Os Providers orquestram as chamadas à API e notificam a UI sobre as mudanças.
- **Data Layer (API Service):** O arquivo `lib/api/ollama_api_service.dart` é responsável por toda a comunicação com a API do Ollama.
- **Models:** Localizada em `lib/models`, define as estruturas de dados usadas em toda a aplicação.

## 3. Estrutura de Arquivos e Diretórios

Abaixo está a descrição dos diretórios e arquivos mais importantes dentro de `lib/`:

```
lib/
├── api/
│   └── ollama_api_service.dart  # Comunicação com a API Ollama.
├── models/
│   ├── chat_message_model.dart  # Modelo para mensagens de chat.
│   ├── model_model.dart         # Modelo para os modelos de linguagem.
│   └── note_model.dart          # Modelo para as anotações.
├── providers/
│   ├── chat_provider.dart       # Gerencia o estado do chat.
│   ├── model_provider.dart      # Gerencia o estado dos modelos.
│   ├── notes_provider.dart      # Gerencia o estado das anotações.
│   ├── system_provider.dart     # Gerencia informações do sistema.
│   └── theme_provider.dart      # Gerencia o tema da aplicação.
├── screens/
│   ├── chat_screen.dart         # Tela de chat.
│   ├── home_screen.dart         # Tela principal com navegação.
│   ├── models_screen.dart       # Tela de gerenciamento de modelos.
│   ├── note_editor_screen.dart  # Tela de edição de notas.
│   ├── notes_screen.dart        # Tela de listagem de notas.
│   └── settings_screen.dart     # Tela de configurações.
├── services/
│   ├── file_service.dart        # Serviço para manipulação de arquivos.
│   └── system_service.dart      # Serviço para obter informações do sistema.
├── widgets/
│   └── bot_message_tile.dart    # Widget para exibir mensagens do bot.
└── main.dart                    # Ponto de entrada da aplicação.
```

## 4. Detalhamento dos Componentes

### `main.dart`
É o ponto de entrada da aplicação. Sua principal função é configurar o `MultiProvider`, que disponibiliza todos os `ChangeNotifier`s (provedores de estado) para a árvore de widgets da aplicação.

### `api/ollama_api_service.dart`
- **`OllamaApiService`**: Classe que centraliza toda a comunicação com o backend do Ollama.
  - `chat(model, messages)`: Envia uma lista de mensagens para o modelo e recebe a resposta em streaming.
  - `getLocalModels()`: Obtém a lista de modelos de linguagem instalados localmente.
  - `pullModel(modelName)`: Inicia o download de um novo modelo, retornando o progresso em streaming.
  - `deleteModel(modelName)`: Remove um modelo local.

### `providers/`
- **`ChatProvider`**:
  - Gerencia o estado da tela de chat, incluindo a lista de mensagens (`messages`) e o status de carregamento.
  - `sendMessage(message)`: Envia a mensagem do usuário para o `OllamaApiService` e processa a resposta em streaming para atualizar a lista de mensagens.

- **`ModelProvider`**:
  - Gerencia a lista de modelos (`models`), o status de download (`pullingProgress`) e os erros.
  - `fetchModels()`: Busca os modelos locais usando o `OllamaApiService`.
  - `pullModel(modelName)`: Inicia o download de um modelo e atualiza a UI com o progresso.
  - `deleteModel(modelName)`: Deleta um modelo e atualiza a lista.

- **`NotesProvider`**:
  - Responsável por carregar, salvar e excluir anotações.
  - Utiliza o `FileService` para interagir com o sistema de arquivos.
  - Mantém a lista de notas (`notes`) que é exibida na `NotesScreen`.

### `screens/`
- **`home_screen.dart`**: Tela principal que contém a `BottomNavigationBar` para navegar entre as telas de Chat, Modelos, Anotações e Configurações.

- **`chat_screen.dart`**: Usa o `ChatProvider` para exibir o histórico de mensagens e permitir que o usuário envie novas mensagens. É aqui que o usuário interage com os LLMs.

- **`models_screen.dart`**: Exibe a lista de modelos disponíveis (obtida do `ModelProvider`) e permite ao usuário baixar novos modelos ou excluir existentes.

- **`notes_screen.dart` e `note_editor_screen.dart`**: Juntas, fornecem a funcionalidade de bloco de notas. A primeira lista as notas salvas e a segunda permite criar/editar o conteúdo de uma nota específica.

- **`settings_screen.dart`**: Oferece opções de configuração, como a mudança de tema (claro/escuro).

### `services/`
- **`FileService`**: Abstrai as operações de leitura e escrita de arquivos no disco, sendo usado principalmente pelo `NotesProvider`.
- **`SystemService`**: Fornece informações sobre o sistema operacional, como a plataforma em que o app está rodando.

## 5. Como Modificar o Projeto

- **Para adicionar uma nova funcionalidade de chat:** Modifique `chat_screen.dart` (UI) e `chat_provider.dart` (lógica). Se precisar de um novo endpoint da API, adicione-o em `ollama_api_service.dart`.

- **Para alterar a aparência de uma tela:** Encontre o arquivo correspondente em `lib/screens/` e edite os widgets.

- **Para adicionar uma nova fonte de dados:** Crie um novo "Service" (similar ao `OllamaApiService`) e um novo "Provider" para gerenciar o estado dos novos dados. Em seguida, crie uma nova "Screen" para exibir esses dados.

- **Para corrigir um bug na busca de modelos:** Comece investigando o `ModelProvider` e o `OllamaApiService` para entender o fluxo de dados e identificar onde o erro pode estar ocorrendo.