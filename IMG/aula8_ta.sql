use F1;
select count(*) from piloto
select count(id) from piloto
select count(anoNasc) from piloto

select count(id) 'pilotos Brasileiros' from piloto
where pais='bra'

SELECT SUM(pontos) AS pontos
FROM piloto JOIN epoca ON piloto.id = epoca.piloto_id
WHERE pais = 'BRA'
AND ano = 1975

SELECT ano, SUM(pontos) AS pontos
FROM piloto JOIN epoca ON piloto.id = epoca.piloto_id
WHERE pais = 'BRA'
GROUP BY ano

SELECT pnome+' '+unome, SUM(pontos) AS pontos
FROM piloto JOIN epoca ON piloto.id = epoca.piloto_id
group by piloto.id, pnome, unome
having sum(pontos)>50
order by sum(pontos) desc

-- Para todos os pilotos que participaram em pelo menos 15 corridas, mostrar o total de pontos em toda a sua carreira, o número de anos em que correram e a média de pontos por ano.

select pnome+' '+unome, SUM(pontos) pontos, count(distinct ano) anos, avg(pontos) 'media pontos'
from piloto
join epoca on piloto.id = epoca.piloto_id
-- where partidas>=15
group by piloto.id, pnome, unome
having sum(partidas)>=15

-------------------------------------
-- Exercícios
-------------------------------------

--1. Devolver o total de pontos de cada equipa em cada ano

select construtor.nome+'-'+motor.nome equipa, equipa.ano, sum(pontos) pontos from equipa
join epoca on piloto_id in(piloto1_id, piloto2_id) and epoca.ano=equipa.ano
join construtor on construtor_id=construtor.id
join motor on motor_id=motor.id
group by construtor_id, construtor.nome, equipa.ano, motor_id, motor.nome

--2. Apresentar uma lista de construtores ordenada por ordem decrescente do número de corridas efectuadas em toda a História
select construtor.nome, sum(partidas) corridas from equipa
join epoca on piloto_id in(piloto1_id, piloto2_id) and epoca.ano=equipa.ano
join construtor on construtor_id=construtor.id
group by construtor_id, construtor.nome
order by corridas desc

--3. Para cada marca de motor, apresentar o número de vitórias que conseguiu em toda a história

select motor.nome motor, sum(vitorias) vitorias from equipa
join epoca on piloto_id in(piloto1_id, piloto2_id) and epoca.ano=equipa.ano
join motor on motor_id=motor.id
group by motor_id, motor.nome
order by vitorias desc