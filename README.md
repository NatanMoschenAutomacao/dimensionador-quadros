# Dimensionador de Quadros (site)

Arquivos:
- `index.html`: o app inteiro (Dimensionamento, Calculadora, Regras).
- `config.js`: endereço e chave pública do Supabase.
- `supabase.sql`: cria a tabela das regras no Supabase, já com as regras atuais da empresa.
- `regras.json`: cópia das regras, usada só se o Supabase não estiver configurado.

## Configurar o Supabase (uma vez)
1. Crie um projeto em supabase.com.
2. Em **SQL Editor > New query**, cole o conteúdo de `supabase.sql` e clique em **Run**.
3. Rode também o `liberar_gravacao.sql`: libera salvar as regras sem login e guarda o histórico de cada gravação.
4. Em **Project Settings > API**, copie a **Project URL** e a chave **anon public** para `config.js`.

## Como funciona
- Qualquer pessoa com o link usa o app e baixa o Excel, sem login.
- As regras são lidas do Supabase quando o app abre.
- Para alterar as regras, vá na aba Regras, edite e clique em **Salvar para todos**. Não precisa login.
- Cada gravação guarda a versão anterior na tabela `regras_historico`, para poder voltar se alguém salvar errado.
