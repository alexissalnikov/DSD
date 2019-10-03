-- �������� ���� - ����� ������, ������ ���������

-- VACUUM ;
-- VACUUM ANALYZE ;
/*
   VACUUM FULL Container;
   VACUUM ANALYZE Container;
   VACUUM FULL ObjectFloat;
   VACUUM ANALYZE ObjectFloat;
   -- VACUUM FULL ContainerLinkObject;
   -- VACUUM ANALYZE ContainerLinkObject;
   VACUUM ANALYZE MovementFloat;
   VACUUM ANALYZE MovementDate;
   VACUUM ANALYZE MovementBoolean;
   VACUUM ANALYZE MovementLinkObject;
   
   VACUUM FULL MovementFloat;
   VACUUM ANALYZE MovementFloat;
   VACUUM FULL MovementDate;
   VACUUM ANALYZE MovementDate;
   VACUUM FULL MovementBoolean;
   VACUUM ANALYZE MovementBoolean;
*/
/*
   VACUUM FULL HistoryCost;
   VACUUM ANALYZE HistoryCost;
   VACUUM FULL SoldTable;
   VACUUM ANALYZE SoldTable;
*/

 VACUUM FULL pg_catalog.pg_statistic;
 VACUUM FULL pg_catalog.pg_attribute; -- **
 VACUUM FULL pg_catalog.pg_class;
 VACUUM FULL pg_catalog.pg_type;
 VACUUM FULL pg_catalog.pg_depend;
 VACUUM FULL pg_catalog.pg_shdepend;
 VACUUM FULL pg_catalog.pg_index;
 VACUUM FULL pg_catalog.pg_attrdef;
 VACUUM FULL pg_catalog.pg_proc;
 -- VACUUM FULL pg_toast.pg_toast_1107196;

 VACUUM ANALYZE pg_catalog.pg_statistic;
 VACUUM ANALYZE pg_catalog.pg_attribute;
 VACUUM ANALYZE pg_catalog.pg_class;
 VACUUM ANALYZE pg_catalog.pg_type ;
 VACUUM ANALYZE pg_catalog.pg_depend;
 VACUUM ANALYZE pg_catalog.pg_shdepend;
 VACUUM ANALYZE pg_catalog.pg_index;
 VACUUM ANALYZE pg_catalog.pg_attrdef;
 VACUUM ANALYZE pg_catalog.pg_proc;
 -- VACUUM ANALYZE pg_toast.pg_toast_1107196;

-- VACUUM FULL CashSessionSnapShot;
-- VACUUM ANALYZE CashSessionSnapShot;

/*
select 1, count(*) from pg_catalog.pg_statistic
union all
select 2, count(*) from pg_catalog.pg_attribute
 union all
select 3, count(*) from pg_catalog.pg_class
 union all
select 4, count(*) from pg_catalog.pg_type 
 union all
select 5, count(*) from pg_catalog.pg_depend
 union all
select 6, count(*) from pg_catalog.pg_shdepend
*/