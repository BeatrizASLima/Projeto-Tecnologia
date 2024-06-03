use F1;

CREATE VIEW PontosEquipas AS
	SELECT epoca.ano, construtor.nome + '-' + motor.nome equipa, sum(pontos) pontos
	FROM construtor
	JOIN equipa ON construtor.id = equipa.construtor_id
	JOIN epoca ON (equipa.ano = epoca.ano AND epoca.piloto_id IN(equipa.piloto1_id, equipa.piloto2_id))
	JOIN motor ON equipa.motor_id = motor.id
	GROUP BY epoca.ano, construtor.id, construtor.nome, motor.nome

select * from PontosEquipas

SELECT ml.ano, ml.equipa McLaren, ml.pontos,
fe.equipa Ferrari, fe.pontos
FROM PontosEquipas ml, PontosEquipas fe
WHERE ml.ano = fe.ano
AND ml.equipa like 'McLaren%'
AND fe.equipa like 'Ferrari%'
AND ml.pontos > fe.pontos

(SELECT pnome + ' ' + unome, pais
FROM piloto)
UNION
(SELECT nome, pais
FROM construtor)
ORDER BY pais

(SELECT pais
FROM piloto)
INTERSECT
(SELECT pais
FROM construtor)
ORDER BY pais


(SELECT pais
FROM piloto)
EXCEPT
(SELECT pais
FROM construtor)
ORDER BY pais

-------------------------

-- 1. Mostrar uma lista dos países que para cada ano tiveram equipas E pilotos da sua nacionalidade a correr

select equipa.ano, construtor.pais from equipa
join construtor on equipa.construtor_id=construtor.id
INTERSECT
select equipa.ano, piloto.pais from equipa
join piloto on piloto.id in (equipa.piloto1_id, equipa.piloto2_id)


-- 2. Listar o nome dos pilotos que **só** participaram em campeonatos quando tinham entre 25 e 30 anos, inclusive. Ou seja, não mostrar os pilotos que participaram em campeonatos quando tinham mais de 30 ou menos de 25 anos.
select pnome+' '+unome piloto--, epoca.ano-piloto.anoNasc
from piloto
join epoca on piloto.id=epoca.piloto_id
where epoca.ano-piloto.anoNasc between 25 and 30
EXCEPT
select pnome+' '+unome--, epoca.ano-piloto.anoNasc
from piloto
join epoca on piloto.id=epoca.piloto_id
where epoca.ano-piloto.anoNasc < 25 OR epoca.ano-piloto.anoNasc > 30


-- 3. Mostrar uma tabela listando, para cada país e cada ano, os construtores e os pilotos desse país que participaram no campeonato desse ano. Ordenar primeiro por ano, depois por país, depois por tipo de participante (Piloto ou Construtor). Eliminar registos onde o país não esteja definido.
select equipa.ano ano, piloto.pais pais, pnome+' '+unome nome, 'piloto' tipo from equipa
join piloto on piloto.id in (equipa.piloto1_id, equipa.piloto2_id)
join pais on piloto.pais=pais.sigla
UNION
select equipa.ano, construtor.pais, construtor.nome, 'construtor' tipo from equipa
join construtor on construtor.id=equipa.construtor_id
join pais on construtor.pais=pais.sigla
ORDER BY ano, pais, tipo


-- 4. Criar uma vista que devolva para cada ano todas as equipas, mas sem nenhuma das chaves alheias da tabela equipa. Em vez disso, deve mostrar o nome completo de cada piloto, o nome completo de uma equipa (construtor e motor) e ainda os dados respectivos de cada piloto e da equipa: nacionalidades, estatísticas de cada piloto em cada ano, anos de nascimento e fundação.
create view DadosEquipas as
select construtor.nome+'-'+motor.nome 'Equipa', construtor.anoFund, pe.nome 'Pais Equipa', equipa.ano, p1.pnome+' '+p1.unome 'Piloto 1', p1.anoNasc 'AnoNasc P1', pp1.nome 'Pais Piloto 1', ep1.partidas 'P1 partidas', ep1.pontos 'P1 pontos', ep1.vitorias 'P1 vitorias', p2.pnome+' '+p2.unome 'Piloto 2', p2.anoNasc 'AnoNasc P2', pp2.nome 'Pais Piloto 2', ep2.partidas 'P2 partidas', ep2.pontos 'P2 pontos', ep2.vitorias 'P2 vitorias' from equipa
join construtor on equipa.construtor_id=construtor.id
join motor on equipa.motor_id=motor.id
join pais pe on construtor.pais=pe.sigla
join piloto p1 on equipa.piloto1_id=p1.id
join epoca ep1 on equipa.piloto1_id=ep1.piloto_id and equipa.ano=ep1.ano
join piloto p2 on equipa.piloto2_id=p2.id
join epoca ep2 on equipa.piloto2_id=ep2.piloto_id and equipa.ano=ep2.ano
join pais pp1 on p1.pais=pp1.sigla
join pais pp2 on p2.pais=pp2.sigla

select * from DadosEquipas
where [P2 pontos]>[P1 pontos]