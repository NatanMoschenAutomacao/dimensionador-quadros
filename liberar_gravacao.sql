-- Rode no Supabase: SQL Editor > New query > cole tudo > Run.
-- Libera ler e salvar as regras para qualquer pessoa com o link do site (sem login)
-- e guarda um histórico de cada gravação, para poder voltar uma versão se alguém salvar errado.

drop policy if exists "logados inserem regras" on public.regras;
drop policy if exists "logados alteram regras" on public.regras;

drop policy if exists "todos inserem regras" on public.regras;
create policy "todos inserem regras" on public.regras
  for insert to anon, authenticated with check (id = 1);

drop policy if exists "todos alteram regras" on public.regras;
create policy "todos alteram regras" on public.regras
  for update to anon, authenticated using (id = 1) with check (id = 1);

-- histórico (só leitura pelo painel do Supabase)
create table if not exists public.regras_historico (
  hist_id   bigint generated always as identity primary key,
  regras    jsonb not null,
  salvo_em  timestamptz not null default now()
);
alter table public.regras_historico enable row level security;

create or replace function public.guardar_historico_regras() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.regras_historico (regras, salvo_em) values (old.regras, old.salvo_em);
  return new;
end $$;

drop trigger if exists trg_historico_regras on public.regras;
create trigger trg_historico_regras before update on public.regras
  for each row execute function public.guardar_historico_regras();

-- Para voltar uma versão: veja public.regras_historico no Table Editor e rode
-- update public.regras set regras = (select regras from public.regras_historico where hist_id = N) where id = 1;
