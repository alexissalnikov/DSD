-- Function: gpSelect_GoodsOnUnitRemains_ForLiki24

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForLiki24 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForLiki24(
    IN inUnitId  Integer,   -- �������������
    IN inSession TVarChar   -- ������ ������������
)
RETURNS TABLE (PharmacyId          Integer
             , ProductId           Integer
             , ProductName         TVarChar
             , Producer            TVarChar
             , Morion              Integer
             , Barcode             TVarChar
             , RegistrationNumber  TVarChar
             , Optima              TVarChar
             , Badm                TVarChar
             , Quantity            TVarChar
             , Price               TVarChar
             , OfflinePrice        TVarChar
             , PickupPrice         TVarChar
             , "10000001 - insurance company #1 id"   TVarChar
             , "10000002 - insurance company #2 id"   TVarChar
             , Vat                 TVarChar
             , PackSize            Integer
             , PackDivisor         Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
    -- ����� ��������� ����� ������ ���������� ����.
    vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
       tmpUnit AS
                   (SELECT Object_Unit.Id AS UnitId
                    FROM gpSelect_Object_Unit_ExportPriceForLiki24(inSession) AS Object_Unit
                    WHERE Object_Unit.Id = inUnitId OR inUnitId = 0
                   )
   , tmpContainerPD AS
                   (SELECT tmpUnit.UnitId
                         , Container.ObjectId
                         , Container.Id
                         , Container.Amount
                         , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                    FROM Container
                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                    WHERE Container.DescId        = zc_Container_CountPartionDate()
                      AND Container.Amount        > 0
                   )
   , tmpRemainsPD AS
                   (SELECT Container.UnitId
                         , Container.ObjectId
                         , Sum(Container.Amount)                                  AS Amount
                    FROM tmpContainerPD AS Container
                         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                              ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                    WHERE ObjectDate_ExpirationDate.ValueData < CURRENT_DATE
                    GROUP BY Container.UnitId
                           , Container.ObjectId
                   )
   , tmpContainer AS
                   (SELECT tmpUnit.UnitId
                         , Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM Container
                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.Amount        <> 0
                   )
   , tmpPartionMI AS
                   (SELECT CLO.ContainerId
                         , MILinkObject_Goods.ObjectId AS GoodsId_find
                         , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                    FROM ContainerLinkObject AS CLO
                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO.ObjectId
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                        -- ������� �������
                        LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                        -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                    ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                   AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                        -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId      = zc_ContainerLinkObject_PartionMovementItem()
                   )
   , tmpRemains AS (SELECT Container.UnitId
                         , Container.ObjectId
                         , tmpPartionMI.GoodsId_find
                         , SUM (Container.Amount)  AS Amount
                         , MAX(MIString_SertificatNumber.ValueData) AS SertificatNumber
                    FROM tmpContainer AS Container
                        LEFT JOIN tmpPartionMI ON tmpPartionMI.ContainerId = Container.Id
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                                ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                               AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()
                        LEFT JOIN MovementItemString AS MIString_SertificatNumber
                                                     ON MIString_SertificatNumber.MovementItemId = tmpPartionMI.MI_IncomeId
                                                    AND MIString_SertificatNumber.DescId = zc_MIString_SertificatNumber()

                    WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                    GROUP BY Container.UnitId
                           , Container.ObjectId
                           , tmpPartionMI.GoodsId_find
                   )
   , tmpGoods AS (SELECT ObjectString.ObjectId AS GoodsId_find, ObjectString.ValueData AS MakerName
                    FROM ObjectString
                    WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpRemains.GoodsId_find FROM tmpRemains)
                      AND ObjectString.DescId   = zc_ObjectString_Goods_Maker()
                   )
   , Remains AS (SELECT tmpRemains.UnitId
                      , tmpRemains.ObjectId
                      , MAX (tmpGoods.MakerName)         AS MakerName
                      , SUM (tmpRemains.Amount)          AS Amount
                      , MAX(tmpRemains.SertificatNumber) AS SertificatNumber
                   FROM
                       tmpRemains
                       LEFT JOIN tmpGoods ON tmpGoods.GoodsId_find = tmpRemains.GoodsId_find
                   GROUP BY tmpRemains.UnitId
                          , tmpRemains.ObjectId
                   HAVING SUM (tmpRemains.Amount) > 0
                 )

   -- �������� ���������� ���� (��� � ����� ������� VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                              , MovementLinkObject_Unit.ObjectId AS UnitId
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                              , MovementLinkObject_Unit.ObjectId
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
       , tmpReserve AS (SELECT tmpMovementChek.UnitId
                             , MovementItem.ObjectId             AS GoodsId
                             , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                        FROM tmpMovementChek
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                        GROUP BY tmpMovementChek.UnitId,
                                 MovementItem.ObjectId
                        )
       , T1 AS (SELECT MIN (Remains.ObjectId) AS ObjectId
                FROM Remains
                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId
                GROUP BY Object_Goods.ObjectCode
               )
      ,  tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_Price_Unit.ChildObjectId
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           )

      , tmpPrice_View AS (SELECT tmpPrice.UnitId
                               , tmpPrice.GoodsId
                               , ROUND(Price_Value.ValueData,2)::TFloat AS Price
                          FROM tmpPrice
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = tmpPrice.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          )
        -- �����-���� �������������
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                 , string_agg(Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc)           AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )
      , Goods_Optima AS (SELECT Object_Goods_Retail.Id
                              , Object_Goods_Juridical.Code
                              , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.Id ORDER BY Object_Goods_Juridical.Id DESC) AS Ord
                         FROM (SELECT DISTINCT Remains.ObjectId FROM Remains) AS Remains
                              INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                                               AND Object_Goods_Retail.RetailId = 4

                              INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                               AND Object_Goods_Juridical.JuridicalId = 59611
                        )
      , Goods_Badm AS (SELECT Object_Goods_Retail.Id
                            , Object_Goods_Juridical.Code
                            , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.Id ORDER BY Object_Goods_Juridical.Id DESC) AS Ord
                       FROM (SELECT DISTINCT Remains.ObjectId FROM Remains) AS Remains
                            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                                             AND Object_Goods_Retail.RetailId = 4

                            INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                             AND Object_Goods_Juridical.JuridicalId = 59610
                      )
        , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                              , ObjectFloat_NDSKind_NDS.ValueData
                        FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                        WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                        )

      SELECT Remains.UnitId                 AS PharmacyId
           , Object_Goods_Retail.Id         AS ProductId
           , REPLACE(Object_Goods_Main.Name, ',', ';')::TVarChar                  AS ProductName
           , REPLACE(Remains.MakerName, ',', ';')::TVarChar                       AS Producer
           , Object_Goods_Main.MorionCode   AS Morion
           , REPLACE(COALESCE (tmpGoodsBarCode.BarCode, ''), ',', ';')::TVarChar  AS Barcode
           , REPLACE(Remains.SertificatNumber, ',', ';')::TVarChar                AS RegistrationNumber
           , REPLACE(Object_Goods_Juridical_Optima.Code, ',', ';')::TVarChar      AS Optima
           , REPLACE(Object_Goods_Juridical_Badm.Code, ',', ';')::TVarChar        AS Badm
           , to_char(Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0) - COALESCE (RemainsPD.Amount, 0),'FM9999990.0999')::TVarChar  AS Quantity
           , to_char(Object_Price.Price,'FM9999990.00')::TVarChar                   AS Price
           , to_char(Object_Price.Price,'FM9999990.00')::TVarChar                   AS OfflinePrice
           , NULL::TVarChar                   AS PickupPrice
           , NULL::TVarChar                 AS "10000001 - insurance company #1 id"
           , NULL::TVarChar                 AS "10000002 - insurance company #2 id"
           , to_char(ObjectFloat_NDSKind_NDS.ValueData,'FM9999990.0999')::TVarChar  AS Vat
           , NULL::Integer                  AS PackSize
           , NULL::Integer                  AS PackDivisor
      FROM Remains
           INNER JOIN T1 ON T1.ObjectId = Remains.ObjectId

           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Remains.ObjectId
                                         AND Object_Goods_Retail.RetailId = 4
           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           INNER JOIN Goods_Optima AS Object_Goods_Juridical_Optima
                                   ON Object_Goods_Juridical_Optima.Id = Remains.ObjectId
                                  AND Object_Goods_Juridical_Optima.Ord = 1

           INNER JOIN Goods_Badm AS Object_Goods_Juridical_Badm
                                 ON Object_Goods_Juridical_Badm.Id = Remains.ObjectId
                                AND Object_Goods_Juridical_Badm.Ord = 1

           LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId

           LEFT OUTER JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId
                                                        AND Object_Price.UnitId = Remains.UnitId

           LEFT OUTER JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId
                                                      AND Reserve_Goods.UnitId = Remains.UnitId
                                                      
           LEFT OUTER JOIN tmpRemainsPD AS RemainsPD ON RemainsPD.ObjectId = Remains.ObjectId
                                                    AND RemainsPD.UnitId = Remains.UnitId

           -- �����-��� �������������
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id

      WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0) - COALESCE (RemainsPD.Amount, 0)) > 0;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_For103UA (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 24.03.20                                                                     *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForLiki24 (inUnitId := 377606, inSession:= '3')