/*SELECT * FROM speedy7_amicra_dev.dm_prop_amicra WHERE REPLACEDBY is NULL or REPLACEDBY = '';*/
/*SELECT count(prop_did) FROM speedy7_amicra_dev.dm_prop_amicra WHERE REPLACEDBY is NULL or REPLACEDBY = '';*/	/* 548819 Leer oder Null */
/*SELECT count(prop_did) FROM speedy7_amicra_dev.dm_prop_amicra WHERE REPLACEDBY <> '';	*//* 2354 Leer */

/*SELECT * FROM speedy7_amicra_dev.dm_prop_amicra WHERE BEN1_ZUSATZ <> '';	*/	/* Keine gefunden, also Feld komplett Leer für alle Artikeln*/
/*SELECT * FROM speedy7_amicra_dev.dm_prop_amicra WHERE BEN3_ZUSATZ <> '';	*/	/* Leer komplett */
/*SELECT * FROM speedy7_amicra_dev.dm_prop_amicra WHERE BEST3 <> ''; 		*/	/* Leer komplett */

/* Find all  */
/*	Menge aller aktuellen Dokumentdatensätze		*/
select  doc_docno, BEST3 from speedy7_amicra_dev.dm_document d
inner join speedy7_amicra_dev.dm_version v 
	on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join speedy7_amicra_dev.dm_prop_amicra p 
	on v.ver_vid=p.prop_did;

/* */ 
/* Ein Dokument unter Angabe der Dokumentnummer (aktuelle Version):*/ 
select * from dm_document d
inner join dm_version v on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join dm_prop_amicra p on v.ver_vid=p.prop_did
where d.doc_docno='000001-019070-B08';

/* Alle Versionen eines Dokuments:*/ 
select * from dm_document d
inner join dm_version v on d.doc_did=v.ver_did
inner join dm_prop_amicra p on v.ver_vid=p.prop_did
where d.doc_docno='000001-019070-B08';

/* Update der Eigenschaft BEST3 eines bestimmten Dokuments:*/ 
update dm_document d
inner join dm_version v on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join dm_prop_amicra p on v.ver_vid=p.prop_did
SET p.BEST3='Test'
where d.doc_docno='000001-019070-B08';

/* Get all KT or NT*/
select d.doc_docno, BEN1 from speedy7_amicra_dev.dm_document d
inner join speedy7_amicra_dev.dm_version v on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join speedy7_amicra_dev.dm_prop_amicra p on v.ver_vid=p.prop_did
where d.doc_docno like 'KT%' or d.doc_docno like 'NT%';

/* Alle Artikeln mit exxakt gleiche Beschreibung */
select p1.prop_did,p2.prop_did,p2.BEN1 from speedy7_amicra_dev.dm_document d
inner join speedy7_amicra_dev.dm_version v 
	on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
	inner join speedy7_amicra_dev.dm_prop_amicra p1 
		on v.ver_vid=p1.prop_did
		inner join speedy7_amicra_dev.dm_prop_amicra p2 
			on v.ver_vid=p2.prop_did and p1.prop_did <> p2.prop_did
where p1.BEN1 = p2.BEN2;

/*	Artikeln mit ISO oder DIN in der Bennenung 1	*/
select doc_docno, BEN1 from test_tables.dm_document d
inner join test_tables.dm_version v 
	on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join test_tables.dm_prop_amicra p on v.ver_vid=p.prop_did
where doc_docno like 'NT%%' and ((BEN1 like '%DIN%') or (BEN1 like '%ISO%'));


/* Artikel unter version 6.0 auswählen*/
        select * from test_tables.dm_document d
        inner join test_tables.dm_version v on d.doc_did=v.ver_did 
        inner join test_tables.dm_prop_amicra p on v.ver_vid=p.prop_did
        WHERE v.ver_major=6
        AND v.ver_minor=0
        AND d.doc_docno='000001-005301-B04';

/* Semi-Nr für eine bestimmte Version und eine bestimmte DocumentNo setzen */
		UPDATE test_tables.dm_document d
        INNER join dm_version v on d.doc_did=v.ver_did
        INNER join dm_prop_amicra p on v.ver_vid=p.prop_did
        SET SEMI_NR = '01-YA'
        WHERE ver_minor= 0 AND ver_major = '6' AND doc_docno = '000001-005301-B04' ;

/* Datensätze ohne Ersetzt durch */
select doc_docno, BEN1 from speedy7_amicra_dev.dm_document d
inner join speedy7_amicra_dev.dm_version v 
	on d.doc_did=v.ver_did and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join speedy7_amicra_dev.dm_prop_amicra p 
	on v.ver_vid=p.prop_did
where REPLACEDBY = '' or REPLACEDBY is null;

/* Semi-Nr für eine Artikel mit der letzten Version setzen  */
SET @max_label = (SELECT MAX(v.ver_label)
	FROM dm_document d
	inner join dm_version v on d.doc_did=v.ver_did 
	inner join dm_prop_amicra p on v.ver_vid=p.prop_did
	WHERE d.doc_docno='000001-014101-B01');

update test_tables.dm_document d
inner join test_tables.dm_version v on d.doc_did=v.ver_did 
inner join test_tables.dm_prop_amicra p on v.ver_vid=p.prop_did
SET p.SEMI_NR = '01-YABB'
where (d.doc_docno = '000001-014101-B01' and v.ver_label = @max_label);

select d.doc_docno, v.ver_label, p.SEMI_NR from dm_document d
inner join dm_version v on d.doc_did=v.ver_did 
inner join dm_prop_amicra p on v.ver_vid=p.prop_did
WHERE d.doc_docno='000001-014101-B01';

/*
select d.doc_docno, v.ver_label from speedy7_amicra_dev.dm_document d
inner join dm_version v on d.doc_did=v.ver_did 
and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join dm_prop_amicra p on v.ver_vid=p.prop_did 
where d.doc_docno like 'KT%' or d.doc_docno like 'NT%' 
	and v.ver_label = (SELECT MAX(v.ver_label)
	FROM dm_document dd
	inner join dm_version v on dd.doc_did=v.ver_did
	inner join dm_prop_amicra p on v.ver_vid=p.prop_did
	WHERE dd.doc_docno= d.doc_docno)
ORDER BY d.doc_docno;
*/

/*
select d.doc_docno as AMICRA_partNo, v.ver_label as AMICRA_last_revision from speedy7_amicra_dev.dm_document d
inner join dm_version v on d.doc_did=v.ver_did 
and d.doc_rev=v.ver_major and d.doc_ver=v.ver_minor
inner join dm_prop_amicra p on v.ver_vid=p.prop_did 
where d.doc_docno like 'KT%' or d.doc_docno like 'NT%' or d.doc_docno like '%-B%' or d.doc_docno like '%-[^0-9.]%'
ORDER BY d.doc_docno;
*/
