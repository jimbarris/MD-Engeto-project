### Reakce na hodnocení lektora



---





Ahoj,

děkuji za hodnocení, konstruktivní kritiku a vlastní pohled lektora a datového analytika. Bylo to pro mě velmi přínosné. Zároveň si dovolím krátce zareagovat, protože si myslím, že je důležitá i má interakce a možná i můj pohled na věc, jako zpětná vazba. Své komentáře přidávám kurzívou.

---



##### Co by šlo vylepšit:



1. V souboru README bych doplnila, čeho se projekt týká - například kdybys chtěl projekt využít jako své portfolio, bylo by dobré vlastně popsat, čeho se projekt týká.



*Rozhodně souhlasím, to mi uteklo. Zapomněl jsem na to ve finále. Projekt byl celkem složitý pro mě, jelikož se jednalo o první projekt podobného typu.*



2\. V tabulce t\_marek\_duda\_project\_SQL\_primary\_final máš chybku v extrakci roku u JOINu czechia\_payroll (řádek č. 18), na kterém select padá. Funkce YEAR() v PostgreSQL neexistuje.



*Děkuji za to. Jelikož v práci díky ERP systému Money děláme na Microsoftu SQL, tak jsem to pomotal. Snad to na podruhé bude správně. :)*



3\. V tabulce t\_marek\_duda\_project\_SQL\_primary\_final je řazení sloupců trochu zmatené - sloupce míchají data z tabulky czechia\_price a czechia\_payroll. Sloupce by bylo lepší seskládat tak, aby byla nejdříve data o cenách a následně data o mzdách, nebo naopak.



*Děkuji za tvůj pohled. A vlastně to chápu. Tady jsem popravdě ten skript několikrát upravoval. A nakonec to vyhodnotil špatně. :)
Já na to koukal tak, že to seřadím podle toho, jak tam ty tabulky JOINuju a že to bude přehledné. Je pravda, že přehledné to musí být až pak v samotném seřazení sloupců a jak se říká: "Chybama se člověk učí."*



4\. V tabulce Main\_questions\_scripts\_and\_views.sql bych zvážila použití okenních funkcí (např. LAG/LEAD) pro zjednodušení a zrychlení dotazů.



*Popravdě, tohle jsme vůbec neprobírali s kolegou. Ale hodil jsem si to do ChatuGPT a to je šikovné. Pro zjednodušení je to super. Některé ty kódy mi přišli dost košaté už. Takže děkuji za obohacení.*

