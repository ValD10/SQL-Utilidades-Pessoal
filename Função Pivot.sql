--	Declarando as variáveis da consulta
------------------------------------ VARIÁVEIS -------------------------------------
 
declare @versao nvarchar(max)
declare @Tabela nvarchar(max)
 
--	Programando as tabelas temporárias
------------------------------------ TEMPORÁRIAS -------------------------------------
 
begin try drop table ##Base end try begin catch end catch
begin try drop table ##Ordenado end try begin catch end catch
begin try drop table ##Final end try begin catch end catch
begin try drop table ##Acumulado end try begin catch end catch
 
--	Temporária que vai filtrar os dados da BDCFINMESES
------------------------------------ BDCFINMESES -------------------------------------
 
select
	Id_Contrato
	,NumContrato
	,Versao
	,convert(date, concat(right(MesAno,4),'-',left(MesAno,2),'-','01')) as MesAno
	,Previsto
	,Realizado
into ##Ordenado
from cidadecomfuturo_bi.dbo.BD_CFIN_MESES
	where 1=1
	and Previsto is not null
 
--	Pegando automaticamente a quantidade de versões existente
------------------------------------ VERSÕES DEFINIDAS -------------------------------------
 
select
	*
	into ##Base
from	(
		select
			distinct Versao
		from cidadecomfuturo_bi.dbo.BD_CFIN_MESES
		order by Versao offset 0 rows
		) a
 
---- Colocando as versões distintas em lista
select
	@versao = STRING_AGG(QUOTENAME(versao), ', ')
from ##Base
 
-- Criando a tabela com base nas definições acima
------------------------------------ TRANSPOSIÇÃO -------------------------------------
 
set @Tabela = '
select
	*
	,row_number()over(partition by NumContrato order by MesAno) as BM
into ##Final
from ##Ordenado
	pivot(
			sum(Previsto)
			for Versao in ('+ @versao + '))P 
			order by NumContrato, MesAno;'
 
--	Executando a tabela
exec sp_executesql @tabela
 
------------------------------------ ACUMULADO -------------------------------------
 
select
	NumContrato
	,convert(int, BM)			as BM
	,max(ValorAcumulado_WBS)	as ValorAcumulado
into ##Acumulado
from cidadecomfuturo_bi.dbo.BD_WBSBM
	group by NumContrato, BM
order by 1
 
-------------------------------- UNIFICANDO AS TABELAS --------------------------------
select
	a.*
	,b.ValorAcumulado	as Acumulado
--	,b.BM
from ##Final a
	left join ##Acumulado b on a.NumContrato collate Latin1_General_CI_AS = b.NumContrato collate Latin1_General_CI_AS
	and a.BM = b.BM
--	where a.NumContrato = '001/2023'