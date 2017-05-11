/*Classements clients par nb occupations : */

select CLI_ID, count(CHB_PLN_CLI_OCCUPE)
from TJ_CHB_PLN_CLI
group by CLI_ID
order by count(CHB_PLN_CLI_OCCUPE) asc; 

/*Classements clients par montant dépensé dans lhotel :*/

select CLI_ID, sum(LIF_MONTANT)
from T_FACTURE fac, T_LIGNE_FACTURES lig
WHERE fac.FAC_ID=lig.FAC_ID
group by CLI_ID
order by sum(LIF_MONTANT) asc;


/*Classements des occupations par mois : */

select CHB_ID,count(CHB_PLN_CLI_OCCUPE), strftime('%m',PLN_JOUR)
from TJ_CHB_PLN_CLI
group by  CHB_ID, strftime('%m',PLN_JOUR)
order by count(CHB_PLN_CLI_OCCUPE);

/*Classements des occupations par trimestre : */

select CHB_ID,count(CHB_PLN_CLI_OCCUPE), strftime('%m',PLN_JOUR) as trim1,
strftime('%m',PLN_JOUR) as trim2,
strftime('%m',PLN_JOUR) as trim3,
strftime('%m',PLN_JOUR) as trim4
from TJ_CHB_PLN_CLI
where trim1 between '01'  AND '03'
and trim2 between '04'  AND '06'
and trim3 between '07'  AND '09'
and trim4 between '10'  AND '12'
group by  CHB_ID, strftime('%m',PLN_JOUR)
order by count(CHB_PLN_CLI_OCCUPE);

/* Faux mais un essai */


/*Montant TTC de chaque ligne de facture (avec remises) : */

Select FAC_ID, sum(LIF_QTE*LIF_MONTANT) as 'montant total TTC sans remise', sum(LIF_QTE*(LIF_MONTANT - LIF_REMISE_MONTANT)) as 'montant TTC si il ya une remise BRUT', sum(LIF_QTE*LIF_MONTANT -(LIF_MONTANT / LIF_REMISE_POURCENT)) as 'MONTANT TTC si il ya une remise en pourcentage'
from T_LIGNE_FACTURES
group by CAST((SUBSTR(FAC_ID,1,6))as integer);


/*Classement du montant total TTC (avec remises) des factures : */

Select FAC_ID, sum(LIF_QTE*LIF_MONTANT) as 'montant total TTC sans remise', sum(LIF_QTE*(LIF_MONTANT - LIF_REMISE_MONTANT)) as 'montant TTC si il ya une remise BRUT', sum(LIF_QTE*LIF_MONTANT -(LIF_MONTANT / LIF_REMISE_POURCENT)) as 'MONTANT TTC si il ya une remise en pourcentage'
from T_LIGNE_FACTURES
group by CAST((SUBSTR(FAC_ID,1,6))as integer);
order by sum(LIF_QTE*LIF_MONTANT) asc;


/*Tarif moyen des chambres par années croissantes : */

select CHB_ID, TRF_DATE_DEBUT as annee, avg(TRF_CHB_PRIX)
from TJ_TRF_CHB
where strftime('%m',TRF_DATE_DEBUT)='01'    /* permet d'exclure les lignes des tarifs hors saisons de la fin d'année, ceux à partir du 09 */
group by annee,CHB_ID;

/*Tarif moyen des chambres par étages et années croissantes : */
select tj.CHB_ID, TRF_DATE_DEBUT as annee, avg(TRF_CHB_PRIX), CHB_ETAGE
from TJ_TRF_CHB tj , T_CHAMBRE c
where strftime('%m',TRF_DATE_DEBUT)='01'
group by annee, tj.CHB_ID,CHB_ETAGE;

/*Chambre la plus cher et en quelle année : */

select 'La chambre la plus chère valait ', max(TRF_CHB_PRIX),'en ', TRF_DATE_DEBUT
from TJ_TRF_CHB;

/*Chambres réservées mais pas occupées : */

select CHB_ID as 'CHAMBRE RESERVES MAIS PAS OCCUPES'
from TJ_CHB_PLN_CLI
where CHB_PLN_CLI_RESERVE=1  /* le 1 signifie oui et 0 non du coup  'champ'=1 ou champ est un état, la réponse est affirmative  */ 
and CHB_PLN_CLI_OCCUPE=0;

/*Taux de résa par chambres : */

/* requete A */

select count(CHB_PLN_CLI_RESERVE)
from TJ_CHB_PLN_CLI
where CHB_PLN_CLI_RESERVE=0;


/* Requete b */

select count (*)
from TJ_CHB_PLN_CLI;


/*On fait la différence entre requete A et B (valeur absolue) que l'on divise par le résultat de la requete B puis on multiplie ce résultat par 100* (environ 53.7%)/



/*Factures réglées avant leur édition*/

select FAC_ID as 'Facture réglés avant leur édition'
from T_FACTURE
where FAC_DATE>FAC_PMT_DATE;

/*Par qui ont été payées ces factures  */

select FAC_ID as 'Facture réglés avant leur édition',CLI_NOM as 'Personnes les ayant payés'
from T_FACTURE, T_CLIENT
where FAC_DATE>FAC_PMT_DATE
and T_CLIENT.CLI_ID=T_FACTURE.CLI_ID

/* Classement  des modes de paiements (par mode Pmt + total généré)*/

Select PMT_CODE, sum(LIF_MONTANT) 
from T_FACTURE, T_LIGNE_FACTURES
where T_FACTURE.FAC_ID=T_LIGNE_FACTURES.FAC_ID
group by PMT_CODE
order by sum(LIF_MONTANT) desc;

/*Voici les diférentes requete pour : */

/* Me créer en tant que client */

 INSERT INTO T_CLIENT(CLI_ID,CLI_NOM,CLI_PRENOM,CLI_ENSEIGNE,TIT_CODE)
 values ('101','KRETZ','Téo','T&corp','M.');

 /* avec les moyens de communications */

Insert Into T_ADRESSE (ADR_ID,ADR_LIGNE1,ADR_CP,ADR_VILLE,CLI_ID)
values ('96','11 rue des roses', '67600', 'KINTZHEIM','101');

Insert Into T_EMAIL(EML_ID,EML_ADRESSE,EML_LOCALISATION,CLI_ID)
values ('40','teo.kretz@gmail.com','Domicile','101');

Insert Into T_TELEPHONE(TEL_ID,TEL_NUMERO,TEL_LOCALISATION,CLI_ID,TYP_CODE)
values ('251','0314159265','Portable','101','TEL');

/* Nouvelle chambre à la date du jour + Nous sommes 3 occupants, max confort, prix 30% supérieur à Chb la plus chère */

Insert Into T_TELEPHONE(TEL_ID,TEL_NUMERO,TEL_LOCALISATION,CLI_ID,TYP_CODE)
values ('251','0314159265','Portable','101','TEL');

Insert Into TJ_TRF_CHB (CHB_ID ,TRF_DATE_DEBUT ,TRF_CHB_PRIX)
values (21, date('now'),max(TRF_CHB_PRIX)+0.3*max(TRF_CHB_PRIX));

/* Règlement en CB */

Insert into T_FACTURE (FAC_ID, FAC_DATE, PMT_CODE, FAC_PMT_DATE, CLI_ID)
values ('2375',date('now'), 'CB',date('now'), '101');

Insert into T_LIGNE_FACTURES(LIF_ID,FAC_ID,LIF_QTE,LIF_REMISE_POURCENT,LIF_REMISE_MONTANT,LIF_MONTANT,LIF_TAUX_TVA)
values ('16791', '2375', '1', '','',665.6,19.6);


/* Seconde Facture édité avc rabais 10%*/

Insert into T_FACTURE (FAC_ID, FAC_DATE, PMT_CODE, FAC_PMT_DATE, CLI_ID)
values ('2376',date('now'), 'CB',date('now'), '101');

Insert into T_LIGNE_FACTURES(LIF_ID,FAC_ID,LIF_QTE,LIF_REMISE_POURCENT,LIF_REMISE_MONTANT,LIF_MONTANT,LIF_TAUX_TVA)
values ('16791', '2375', '1', '10','',665.6,19.6);

/*J'ai préféré le insert au update car l'on édite une 2nd facture ainsi l'on peut laiser des traces de la première*/