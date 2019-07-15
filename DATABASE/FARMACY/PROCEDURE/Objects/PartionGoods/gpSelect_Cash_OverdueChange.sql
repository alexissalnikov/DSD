-- Function: gpSelect_Cash_OverdueChange()

DROP FUNCTION IF EXISTS gpSelect_Cash_OverdueChange (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_OverdueChange (
    IN inUnitId         Integer,       -- �������������
    IN inGoodsId        Integer,       -- �����
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (ContainerID Integer,
               GoodsID Integer, GoodsCode Integer, GoodsName TVarChar,
               Amount TFloat, ExpirationDate TDateTime,
               ContainerPGID Integer, AmountPG TFloat, ExpirationDatePG TDateTime,
               BranchDate TDateTime, Invnumber TVarChar, FromName TVarChar, ContractName TVarChar,
               ExpirationDateDialog TDateTime, AmountDialog TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGuudsId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);


  RETURN QUERY
  WITH   tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = inUnitId
                            AND Container.ObjectId      = inGoodsId
                            AND Container.Amount <> 0
                         )
       , tmpExpirationDate AS (SELECT tmp.Id       AS ContainerId
                                    , MIDate_ExpirationDate.ValueData
                                    , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId
                               FROM tmpContainer AS tmp
                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                ON ContainerLinkObject_MovementItem.Containerid = tmp.Id
                                                               AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                  LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                  -- ������� �������
                                  LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                  -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                              ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                             AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                  -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                  LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                       -- AND 1=0
                                   LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )

  SELECT Container.ID                                                      AS ContainerID
       , Object_Goods.ID                                                   AS GoodsID
       , Object_Goods.ObjectCode                                           AS GoodsCode
       , Object_Goods.ValueData                                            AS GoodsName
       , Container.Amount                                                  AS Amount
       , COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) :: TDateTime AS ExpirationDate

       , Container_PG.Id                                                   AS ContainerPGID
       , COALESCE (Container_PG.Amount, Container.Amount)                  AS AmountPG
       , ObjectFloat_PartionGoods_ExpirationDate.ValueData                 AS ExpirationDatePG

       , MovementDate_Branch.ValueData                                     AS BranchDate
       , Movement_Income.Invnumber                                         AS Invnumber
       , Object_From.ValueData                                             AS FromName
       , Object_Contract.ValueData                                         AS ContractName

       , COALESCE (ObjectFloat_PartionGoods_ExpirationDate.ValueData,
                   tmpExpirationDate.ValueData, zc_DateEnd())              AS ExpirationDateDialog
       , COALESCE (Container_PG.Amount, Container.Amount)                  AS AmountDialog
  FROM tmpContainer AS Container

       LEFT JOIN tmpExpirationDate ON tmpExpirationDate.ContainerId = Container.Id

       LEFT JOIN Container AS Container_PG
                           ON Container_PG.ParentId = Container.Id
                          AND Container_PG.DescId = zc_Container_CountPartionDate()
                          AND Container_PG.Amount <> 0

       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId


       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container_PG.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
       LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = ContainerLinkObject.ObjectId

       LEFT JOIN ObjectDate AS ObjectFloat_PartionGoods_ExpirationDate
                            ON ObjectFloat_PartionGoods_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                           AND ObjectFloat_PartionGoods_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

       LEFT JOIN Movement AS Movement_Income ON Movement_Income.ID = tmpExpirationDate.MovementID

       LEFT JOIN MovementDate AS MovementDate_Branch
                              ON MovementDate_Branch.MovementId = Movement_Income.ID
                             AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement_Income.ID
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = Movement_Income.ID
                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

  ORDER BY 5;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.07.19                                                       *
*/

-- ����
-- select * from gpSelect_Cash_OverdueChange(inUnitID := 183292 , inGoodsId := 16597 ,  inSession := '3');