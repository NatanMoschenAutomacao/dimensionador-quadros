-- Rode no Supabase: SQL Editor > New query > cole tudo > Run.
-- Cria a tabela das regras de dimensionamento, com leitura liberada para o site
-- e gravação só para usuários logados (projetistas cadastrados em Authentication > Users).

create table if not exists public.regras (
  id        int primary key,
  regras    jsonb not null,
  salvo_em  timestamptz not null default now(),
  salvo_por text
);

alter table public.regras enable row level security;

drop policy if exists "todos leem regras" on public.regras;
create policy "todos leem regras" on public.regras
  for select to anon, authenticated using (true);

drop policy if exists "logados inserem regras" on public.regras;
create policy "logados inserem regras" on public.regras
  for insert to authenticated with check (id = 1);

drop policy if exists "logados alteram regras" on public.regras;
create policy "logados alteram regras" on public.regras
  for update to authenticated using (id = 1) with check (id = 1);

-- regras atuais da empresa (as que estavam salvas no app)
insert into public.regras (id, regras, salvo_por)
values (1, '{"params": {"RENDIMENTO_MOTOR": 0.75, "FP_MOTOR": 0.72, "FP_MOTOR_24VDC": 0.5, "FP_ILUMINACAO": 0.85, "FATOR_FAIXA_Q": 1.25, "FAIXA_Q_MINIMA": 0.63, "FATOR_DISJ_GERAL_220V": 1.25, "FATOR_DISJ_GERAL_380V": 1.5, "DISJ_GERAL_MINIMO_220V": 32, "DISJ_GERAL_MINIMO_380V": 16, "FATOR_PROTECAO_24VDC": 2, "MOTORES_24VDC_POR_FONTE": 2, "W_MAX_2_MOTORES_POR_FONTE": 140, "PROTECAO_24VDC_MINIMA": 4, "FATOR_PROTECAO_FONTE_24VDC": 2, "ILUMINACAO_W_MAX_POR_CIRCUITO": 0, "PROTECAO_ILUMINACAO": "16A", "PROGRAMADORES_COM_TRAFO": "GALCON", "CABO_MOTOR_3F": "(FFF+T) 2,5 / 750 / 70°", "CABO_BIFASICO": "(FF) 2,5 / 750 / 70°", "CABO_MONOFASICO": "(F+N) 2,5 / 750 / 70°", "QUEDA_MAX_PCT": 4, "FP_ILUMINACAO_MONO": 0.7, "PROTECAO_ILUMINACAO_MONO": "10A", "FATOR_PROTECAO_RESISTIVO": 1, "CABO_POR_PROTECAO": "16:2,5; 25:4; 32:6; 50:10; 63:16; 80:25; 100:35; 125:50; 160:70"}, "catalogo": [{"contem": "CHAVE BOIA", "tipo": "IGNORAR", "cv": "", "w": "", "nome": "", "faixa": "", "obs": "só comando"}, {"contem": "VALVULA", "tipo": "IGNORAR", "cv": "", "w": "", "nome": "", "faixa": "", "obs": "só comando"}, {"contem": "ZANNAFERTI", "tipo": "IGNORAR", "cv": "", "w": "", "nome": "", "faixa": "", "obs": ""}, {"contem": "MOTOREDUTOR+IMPORTADO+100", "tipo": "MOTOR_24VDC", "cv": "", "w": 140, "nome": "SOMBREAMENTO", "faixa": "", "obs": "6164: 100W → 140W"}, {"contem": "MOTOREDUTOR+IMPORTADO+180", "tipo": "MOTOR_24VDC", "cv": "", "w": 180, "nome": "SOMBREAMENTO", "faixa": "", "obs": ""}, {"contem": "MOTOREDUTOR+IMPORTADO", "tipo": "MOTOR_24VDC", "cv": "", "w": 120, "nome": "SOMBREAMENTO", "faixa": "", "obs": "140Nm = 120W"}, {"contem": "MOTOREDUTOR+MACOPEMA", "tipo": "MOTOR_3F", "cv": 0.21, "w": "", "nome": "SOMBREAMENTO", "faixa": "", "obs": "1/6 CV → 0,21 CV"}, {"contem": "EXAUSTOR+36", "tipo": "MOTOR_3F", "cv": 0.75, "w": "", "nome": "EXAUSTOR", "faixa": "", "obs": "1 CV → 0,75 CV"}, {"contem": "EXAUSTOR", "tipo": "MOTOR_3F", "cv": "", "w": "", "nome": "EXAUSTOR", "faixa": "", "obs": ""}, {"contem": "CIRCULADOR", "tipo": "MOTOR_3F", "cv": "", "w": "", "nome": "CIRCULADOR", "faixa": "1,6 - 2,5", "obs": "6106"}, {"contem": "AGITADOR", "tipo": "MOTOR_2F", "cv": "", "w": 800, "nome": "AGITADOR", "faixa": "", "obs": "800W bifásico"}, {"contem": "AQUECEDOR", "tipo": "RESISTIVO_3F", "cv": "", "w": "", "nome": "AQUECEDOR ELÉTRICO", "faixa": "", "acompanha": "DISSIPADOR:0,75", "obs": "6112: cada aquecedor leva 1 dissipador 0,75 CV"}, {"contem": "LAMPADA", "tipo": "ILUMINACAO", "cv": "", "w": "", "nome": "", "faixa": "", "obs": "W × quantidade"}], "sistemas": [{"contem": "REFRIGERACAO|PAD/FAN|PAD FAN|EXAUSTAO|EXAUSTORES", "titulo": "SISTEMA DE REFRIGERAÇÃO PAD/FAN", "ordem": 1, "motor": "EXAUSTOR", "bomba": "MOTOBOMBA PAD/FAN"}, {"contem": "CIRCULACAO", "titulo": "SISTEMA DE CIRCULAÇÃO DE AR", "ordem": 2, "motor": "CIRCULADOR", "bomba": ""}, {"contem": "MICROASPERSAO", "titulo": "SISTEMA DE MICROASPERSÃO", "ordem": 3, "motor": "MICROASPERSÃO", "bomba": "MICROASPERSÃO"}, {"contem": "GOTEJO|GOTEJAMENTO", "titulo": "SISTEMA DE GOTEJO", "ordem": 4, "motor": "GOTEJO", "bomba": "GOTEJO"}, {"contem": "AQUECIMENTO", "titulo": "SISTEMA DE AQUECIMENTO ELÉTRICO", "ordem": 5, "motor": "", "bomba": "", "cor": "D9D9D9"}, {"contem": "NEBULIZACAO", "titulo": "SISTEMA DE NEBULIZAÇÃO", "ordem": 5, "motor": "NEBULIZAÇÃO", "bomba": "NEBULIZAÇÃO"}, {"contem": "CORTINA", "titulo": "SISTEMA DE SOMBREAMENTO / CORTINA / JANELA IMPORTADO", "ordem": 6, "motor": "CORTINA", "bomba": "", "cor": "C9C9C9"}, {"contem": "MOVIMENTACAO|SOMBREAMENTO", "titulo": "SISTEMA DE SOMBREAMENTO", "ordem": 6, "motor": "SOMBREAMENTO", "bomba": "", "cor": "C9C9C9"}, {"contem": "FOTOPERIODO|ILUMINACAO", "titulo": "SISTEMA DE ILUMINAÇÃO", "ordem": 8, "motor": "", "bomba": ""}], "faixasQ": [[0.1, 0.16], [0.16, 0.25], [0.25, 0.4], [0.4, 0.63], [0.63, 1], [1, 1.6], [1.6, 2.5], [2.5, 4], [4, 6.3], [6.3, 10], [10, 16], [16, 20], [20, 25], [25, 32]], "geral": [16, 20, 25, 32, 40, 50, 63, 80, 100, 125, 160, 200, 250, 300, 350, 400]}'::jsonb, 'importado do app')
on conflict (id) do nothing;
