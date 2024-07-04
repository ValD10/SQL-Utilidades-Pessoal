------------------------ DECLARAÇÃO DE VARIÁVEIS
declare 
@dt1 as date, 
@dt2 as date, 
@dt3 as date, 
@dt4 as date, 
@dt5 as date, 
@dt6 as date, 
@dt7 as date

------------------------ DEFINIÇÃO DAS VARIÁVEIS
set @dt1 = convert(date,dateadd(month,-0,cast(dateAdd(month, dateDiff(month,0,getdate()), 0) as date)))
set @dt2 = getdate()
set @dt3 = dateadd(mm,-1,@dt1)
set @dt4 = dateadd(mm,-1,@dt2)
set @dt5 = convert(date,dateadd(year,-0,cast(dateAdd(year, dateDiff(year,0,getdate()), 0) as date)))
set @dt6 = convert(date,getdate())
set @dt7 = dateadd(day,-(datepart(day,getdate())),getdate())

------------------------ CONSULTA DAS VARIÁVEIS
select 
	 @dt1 as dt1	---- Primeiro dia do mês
	,@dt2 as dt2	---- Dia atual
	,@dt3 as dt3	---- Primeiro dia do MÊS PASSADO
	,@dt4 as dt4	---- Equivalente do dia atual no MÊS PASSADO
	,@dt5 as dt5	---- Primeiro dia do ano
	,@dt6 as dt6	---- Dia atual modelo dois
	,@dt7 as dt7	---- Último dia do mês passado
