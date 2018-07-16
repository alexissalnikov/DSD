﻿-- возвращает скрипт ПРОЦ.

DROP FUNCTION IF EXISTS gpSelect_ReplProc (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ReplProc (BigInt, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplProc(
    IN inOId      BigInt,       --
    IN inSession  TVarChar      -- сессия пользователя
)
RETURNS TABLE (ProcText Text)
AS
$BODY$
   DECLARE vbDrop Text;
   DECLARE vbRes  Text;
BEGIN


     -- Результат
     vbDrop:= COALESCE ((SELECT FORMAT ('DROP %s IF EXISTS %s;'
                                      , CASE WHEN proisagg THEN 'AGGREGATE' ELSE 'FUNCTION' END
                                      , p.oid :: regprocedure
                                       ) AS ResDrop
                         FROM pg_catalog.pg_proc p
                              INNER JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
                         WHERE p.oid = inOId
                           AND p.ProName NOT ILIKE ('zc_%')
                        ), '');

     -- Результат
     vbRes := (SELECT UNNEST (STRING_TO_ARRAY (pg_catalog.pg_get_functiondef (inOId), '')) :: Text);


     -- Результат
     IF vbRes ILIKE 'IMMUTABLE'
     THEN
         RETURN QUERY
           SELECT vbDrop
               || CHR(10)
               || CASE WHEN LOWER (p.ProName) NOT IN (LOWER ('gpSelect_ReplProc')
--                                                    , LOWER ('gpExecSql')
  --                                                  , LOWER ('lfExecSql')
                                                     )
                  THEN
                  SPLIT_PART (vbRes, 'LANGUAGE plpgsql', 1)
               || ' AS '
               || CHR(10) || ' $' || 'BODY' || '$ '
               || SPLIT_PART (vbRes, '$function$', 2)
               || ' $' || 'BODY' || '$ '
               || CHR(10) || ' LANGUAGE plpgsql IMMUTABLE;'
               -- || CHR(10) || ' --- replicate ---' || CHR(10)
                  ELSE ''
                  END
           FROM  pg_catalog.pg_proc p
           WHERE p.oid = inOId
          ;
     ELSE
         RETURN QUERY
           SELECT vbDrop
               || CHR(10)
               || CASE WHEN LOWER (p.ProName) NOT IN (LOWER ('gpSelect_ReplProc')
    --                                                , LOWER ('gpExecSql')
--                                                    , LOWER ('lfExecSql')
                                                     )
                  THEN
                  SPLIT_PART (vbRes, 'LANGUAGE plpgsql', 1)
               || ' AS '
               || CHR(10) || ' $' || 'BODY' || '$ '
               || SPLIT_PART (vbRes, '$function$', 2)
               || ' $' || 'BODY' || '$ '
               || CHR(10) || ' LANGUAGE plpgsql VOLATILE;'
               -- || CHR(10) || ' --- replicate ---' || CHR(10)
                  ELSE ''
                  END
           FROM  pg_catalog.pg_proc p
           WHERE p.oid = inOId
          ;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- 1479135194
-- SELECT * FROM gpSelect_ReplProc  (inOId:= 1479135194, inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
