-- Function: gpReport_OrderInternalBasis_Olap ()

DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap_Print (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalBasis_Olap_Print (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inFromId             Integer   ,    -- �� ����
    IN inToId               Integer   ,    -- ���� 
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS SETOF refcursor   
AS
$BODY$
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN

    -- ����������� �� ������
    CREATE TEMP TABLE _tmpReport (InvNumber TVarChar, DayOfWeekName TVarChar, DayOfWeekNumber Integer, GoodsGroupNameFull TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, Amount TFloat) ON COMMIT DROP;
    
    INSERT INTO _tmpReport (InvNumber, DayOfWeekName, DayOfWeekNumber, GoodsGroupNameFull, GoodsCode, GoodsName, GoodsKindId, GoodsKindName, Amount)
    
         SELECT tmpReport.InvNumber
              , tmpReport.DayOfWeekName
              , tmpReport.DayOfWeekNumber
              , tmpReport.GoodsGroupNameFull
              , tmpReport.GoodsCode
              , tmpReport.GoodsName
              , tmpReport.GoodsKindId
              , tmpReport.GoodsKindName
              , tmpReport.Amount
         FROM gpReport_OrderInternalBasis_Olap (inStartDate, inEndDate, inGoodsGroupId, inGoodsId, inFromId, inToId, inSession) AS tmpReport
         WHERE COALESCE (tmpReport.Amount, 0) <> 0;
 
    -------

    OPEN Cursor1 FOR
    SELECT MAX (tmp.DayOfWeekName1) :: TVarChar AS DayOfWeekName1
         , MAX (tmp.DayOfWeekName2) :: TVarChar AS DayOfWeekName2
         , MAX (tmp.DayOfWeekName3) :: TVarChar AS DayOfWeekName3
         , MAX (tmp.DayOfWeekName4) :: TVarChar AS DayOfWeekName4
         , MAX (tmp.DayOfWeekName5) :: TVarChar AS DayOfWeekName5
         , MAX (tmp.DayOfWeekName6) :: TVarChar AS DayOfWeekName6
         , MAX (tmp.DayOfWeekName7) :: TVarChar AS DayOfWeekName7
         
         , STRING_AGG (DISTINCT tmp.InvNumber1, '; ') :: TVarChar AS InvNumber1
         , STRING_AGG (DISTINCT tmp.InvNumber2, '; ') :: TVarChar AS InvNumber2
         , STRING_AGG (DISTINCT tmp.InvNumber3, '; ') :: TVarChar AS InvNumber3
         , STRING_AGG (DISTINCT tmp.InvNumber4, '; ') :: TVarChar AS InvNumber4
         , STRING_AGG (DISTINCT tmp.InvNumber5, '; ') :: TVarChar AS InvNumber5
         , STRING_AGG (DISTINCT tmp.InvNumber6, '; ') :: TVarChar AS InvNumber6
         , STRING_AGG (DISTINCT tmp.InvNumber7, '; ') :: TVarChar AS InvNumber7
    FROM (SELECT CASE WHEN _tmpReport.DayOfWeekNumber = 1 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName1
               , CASE WHEN _tmpReport.DayOfWeekNumber = 2 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName2
               , CASE WHEN _tmpReport.DayOfWeekNumber = 3 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName3
               , CASE WHEN _tmpReport.DayOfWeekNumber = 4 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName4
               , CASE WHEN _tmpReport.DayOfWeekNumber = 5 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName5
               , CASE WHEN _tmpReport.DayOfWeekNumber = 6 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName6
               , CASE WHEN _tmpReport.DayOfWeekNumber = 7 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName7
               
               , CASE WHEN _tmpReport.DayOfWeekNumber = 1 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber1
               , CASE WHEN _tmpReport.DayOfWeekNumber = 2 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber2
               , CASE WHEN _tmpReport.DayOfWeekNumber = 3 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber3
               , CASE WHEN _tmpReport.DayOfWeekNumber = 4 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber4
               , CASE WHEN _tmpReport.DayOfWeekNumber = 5 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber5
               , CASE WHEN _tmpReport.DayOfWeekNumber = 6 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber6
               , CASE WHEN _tmpReport.DayOfWeekNumber = 7 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber7
          FROM _tmpReport
          ) AS tmp
  /*  GROUP BY tmp.DayOfWeekName1 :: TVarChar
           , tmp.DayOfWeekName2 :: TVarChar
           , tmp.DayOfWeekName3 :: TVarChar
           , tmp.DayOfWeekName4 :: TVarChar
           , tmp.DayOfWeekName5 :: TVarChar
           , tmp.DayOfWeekName6 :: TVarChar
           , tmp.DayOfWeekName7 :: TVarChar*/
    ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
    SELECT _tmpReport.GoodsGroupNameFull
         , _tmpReport.GoodsCode
         , _tmpReport.GoodsName
         , _tmpReport.DayOfWeekName
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount1_fr --"�����."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount2_fr --"�����."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount3_fr --"�����."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount4_fr --"�����."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount5_fr --"�����."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount6_fr --"�����."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount7_fr --"�����."  freeze
      
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount1 --"���."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount2 --"���."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount3 --"���."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount4 --"���."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount5 --"���."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount6 --"���."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount7 --"���."
    FROM _tmpReport
    GROUP BY _tmpReport.GoodsGroupNameFull
           , _tmpReport.GoodsName
           , _tmpReport.GoodsCode
           , _tmpReport.DayOfWeekName
    HAVING SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0 
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
    ;
    
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.03.20         *
*/

-- ����
--