create database TEATR_36;

create table Rezyserzy(
	RezyserKod int primary key,
	Imie varchar(50) not null,
	Nazwisko varchar(100) not null
);

create table Sztuki(
	SztukaKod int primary key,
	Tytul varchar(50) not null,
	RezyserKod int references Rezyserzy(RezyserKod) not null,
	Opis text null,
	DataPremieraOd date not null,
	DataPremieraDo date null
);

create table Spektakle(
	SpektaklKod int primary key,
	SztukaKod int references Sztuki(SztukaKod) not null,
	DataIGodzinaSpektaklu datetime not null,
	LiczbaDostepnychBiletow int null default 100,
	CenaBiletu money not null
);

create table Rezerwacje(
	RezerwacjaKod int identity(1,1) primary key,
	DataRezerwacji date not null,
	CalkowitaWartosc money not null
);
create table Bilety(
	BiletKod int identity(1,1) primary key,
	SpektatklKod int references Spektakle(SpektaklKod) not null,
	RezerwacjaKod int references Rezerwacje(RezerwacjaKod) null
);


alter table Sztuki
alter column Tytul varchar(100) not null;

insert into Rezyserzy (RezyserKod, Imie, Nazwisko)
values(1, 'andrzej', 'nazandrzej');
insert into Rezyserzy (RezyserKod, Imie, Nazwisko)
values(2, 'mikolaj', 'nazmikolaj');
insert into Rezyserzy (RezyserKod, Imie, Nazwisko)
values(3, 'stefan', 'nazstefan');

insert into Sztuki (SztukaKod, Tytul, RezyserKod, Opis, DataPremieraOd, DataPremieraDo)
values (1, 'lala', 1, 'opis lala', '2500-01-01', '2501-01-01');
insert into Sztuki (SztukaKod, Tytul, RezyserKod, Opis, DataPremieraOd, DataPremieraDo)
values (2, 'papa', 1, 'opis papa', '2600-01-01', '2601-01-01');
insert into Sztuki (SztukaKod, Tytul, RezyserKod, Opis, DataPremieraOd, DataPremieraDo)
values (3, 'kaka', 1, 'opis gdfgf', '2500-01-02', '2501-02-01');
insert into Sztuki (SztukaKod, Tytul, RezyserKod, Opis, DataPremieraOd, DataPremieraDo)
values (4, 'sasa', 1, 'opis fgdfg', '2700-01-01', '2701-01-01');
insert into Sztuki (SztukaKod, Tytul, RezyserKod, Opis, DataPremieraOd, DataPremieraDo)
values (5, 'nana', 1, 'opis nana', '2700-02-02', '2701-03-04');


insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (1, 1, '2500-01-02 14:30:00', 100, 200); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (2, 1, '2500-01-03 15:30:00', 110, 210); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (3, 2, '2600-01-04 11:30:00', 200, 200); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (4, 2, '2600-01-05 10:30:00', 300, 270); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (5, 3, '2500-01-02 16:30:00', 400, 260); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (6, 3, '2500-02-04 15:30:00', 500, 250); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (7, 4, '2700-07-04 14:30:00', 600, 240); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (8, 4, '2700-06-02 19:30:00', 700, 230); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (9, 5, '2700-05-01 11:30:00', 800, 220); 
insert into Spektakle (SpektaklKod, SztukaKod, DataIGodzinaSpektaklu, LiczbaDostepnychBiletow, CenaBiletu)
values (10, 5, '2700-04-03 13:30:00', 900, 210); 

insert into Bilety (SpektatklKod)
values (1);
insert into Bilety (SpektatklKod)
values (2);
insert into Bilety (SpektatklKod)
values (3);
insert into Bilety (SpektatklKod)
values (4);

Go
create or alter procedure RezerwujBilety 
	@SpektaklKod int, @DataSpektaklu date, @LiczbaBiletow int
as	
begin
	declare @wynik1kodspektatklu int;
	declare @wynik1cenabiletu money;
	select top 1 @wynik1kodspektatklu = s.SpektaklKod,
				 @wynik1cenabiletu = s.CenaBiletu
				 from Spektakle s
				 join Sztuki sz on sz.SztukaKod = s.SztukaKod
	where s.SpektaklKod = @SpektaklKod
	and s.LiczbaDostepnychBiletow >= @LiczbaBiletow
	and cast(DataIGodzinaSpektaklu as date) = @DataSpektaklu;

	if @wynik1kodspektatklu is not null
		begin
			begin try
				begin transaction
					insert into Rezerwacje (DataRezerwacji, CalkowitaWartosc)
					values(@DataSpektaklu, @wynik1cenabiletu * @LiczbaBiletow);

					declare @kodrezerwacji int;
					select top 1 @kodrezerwacji = r.RezerwacjaKod from Rezerwacje r
					order by RezerwacjaKod desc;

					declare @i int = 1;
					while @i < @LiczbaBiletow
					begin
						insert into Bilety (SpektatklKod, RezerwacjaKod)
						values(@SpektaklKod, @kodrezerwacji);
						set @i = @i + 1
					end

					update Spektakle
					set LiczbaDostepnychBiletow = LiczbaDostepnychBiletow - @LiczbaBiletow
					where SpektaklKod = @wynik1kodspektatklu;

					select * from Rezerwacje
					where RezerwacjaKod = @kodrezerwacji;


					commit
			end try
			begin catch
				if @@TRANCOUNT > 0
					begin
						rollback
					end
			end catch
		end
	else
		begin
			declare @wynik1sztukakod int;
			select @wynik1sztukakod = SztukaKod from Spektakle
			where SpektaklKod = @SpektaklKod
			declare @wynik2kodspektatklu int;
			select top 1 @wynik2kodspektatklu = sp.SpektaklKod from Spektakle sp
			where sp.SztukaKod = @wynik1sztukakod
			and cast(sp.DataIGodzinaSpektaklu as date) > @DataSpektaklu
			and sp.LiczbaDostepnychBiletow > @LiczbaBiletow;

			if @wynik2kodspektatklu is not null

				begin	
					print 'inny spektakl tej samej sztuki' 
					select sz.Tytul, sp.DataIGodzinaSpektaklu, sp.LiczbaDostepnychBiletow, sp.CenaBiletu from Spektakle sp
					join Sztuki sz on sp.SztukaKod = sz.SztukaKod
					where SpektaklKod = @wynik2kodspektatklu;
				end
			else
				begin
					declare @rezyserkod int;
					select @rezyserkod = sz.RezyserKod from Spektakle s join Sztuki sz on s.SztukaKod = sz.SztukaKod
					where s.SpektaklKod = @SpektaklKod
					declare @wynik3kodspektatklu int;
					select top 1 @wynik3kodspektatklu = s.SpektaklKod from Spektakle s 
					join Sztuki sz on s.SztukaKod = sz.SztukaKod
					where sz.RezyserKod = @rezyserkod
					and cast(s.DataIGodzinaSpektaklu as date) > @DataSpektaklu
					and s.LiczbaDostepnychBiletow > @LiczbaBiletow;
					
					if @wynik3kodspektatklu is not null
						begin
							DECLARE @Tytul NVARCHAR(255);
							DECLARE @DataIGodzina DATETIME;
							DECLARE @LiczbaBiletow2 INT;
							DECLARE @CenaBiletu DECIMAL(10, 2);

							DECLARE spektakl_cursor CURSOR FOR
							SELECT sz.Tytul, sp.DataIGodzinaSpektaklu, sp.LiczbaDostepnychBiletow, sp.CenaBiletu
							FROM Spektakle sp
							JOIN Sztuki sz ON sp.SztukaKod = sz.SztukaKod
							WHERE sp.SpektaklKod = @wynik3kodspektatklu;

							OPEN spektakl_cursor;

							FETCH NEXT FROM spektakl_cursor
							INTO @Tytul, @DataIGodzina, @LiczbaBiletow2, @CenaBiletu;

							WHILE @@FETCH_STATUS = 0
							BEGIN
								PRINT 'Tytul: ' + @Tytul;
								PRINT 'Data i godzina: ' + CAST(@DataIGodzina AS NVARCHAR);
								PRINT 'Liczba dostępnych biletów: ' + CAST(@LiczbaBiletow AS NVARCHAR);
								PRINT 'Cena biletu: ' + CAST(@CenaBiletu AS NVARCHAR);
								PRINT '---------------------------------------';

								FETCH NEXT FROM spektakl_cursor
								INTO @Tytul, @DataIGodzina, @LiczbaBiletow, @CenaBiletu;
							END;

							CLOSE spektakl_cursor;
							DEALLOCATE spektakl_cursor;
						end
					else
						begin
							print 'Brak dostepnych spektatkli spelniajacych kryteria';
						end
				end
		end
		
end;

Go
exec RezerwujBilety 1, '2500-01-02', 5;
exec RezerwujBilety 1, '2500-01-01', 5;
exec RezerwujBilety 1, '2600-01-01', 5;
exec RezerwujBilety 1, '3500-01-01', 5;

create index idx_1
on Spektakle(SztukaKod);

create unique index idx_2
on Rezyserzy(Imie, Nazwisko);

create index idx_3
on Spektakle(DataIGodzinaSpektaklu);

create index idx_4
on Bilety(SpektatklKod);

create index idx_5
on Rezerwacje(DataRezerwacji, CalkowitaWartosc);