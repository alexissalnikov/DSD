-- Function: gpSelect_MovementItem_Send_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send_Child(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ContainerId TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             , PartionDateKindName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId := inSession;


    -- ���� + 0 �������
    vbDate_0 := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
    -- ���� + 6 �������
    vbDate_6:= vbDate_0
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- ���� + 1 �����
    vbDate_1:= vbDate_0
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               )
               -- ������: ������� ��� 9 ����, ����� �� 60 ���� ������������ - ������ ��� ���
             + INTERVAL '9 DAY'
             ;


     RETURN QUERY
     WITH
     tmpMI_Child AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Child()
                     )

   , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                     , MovementItemFloat.ValueData :: Integer AS ContainerId
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )
    --
   , tmpContainer AS (SELECT tmp.ContainerId
                           , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                           , COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())  AS ExpirationDate
                           , CASE WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_0 THEN zc_Enum_PartionDateKind_0()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_1 THEN zc_Enum_PartionDateKind_1()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_1   AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_6 THEN zc_Enum_PartionDateKind_6()
                                  ELSE 0
                             END                                                       AS PartionDateKindId
                      FROM tmpMIFloat_ContainerId AS tmp
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = tmp.ContainerId
                                                        AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                           LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                      ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                     AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()

                           LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                         ON CLO_MovementItem.Containerid = tmp.ContainerId
                                                        AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                           -- ������� �������
                           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                           -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                           -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                      
                           /*LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
                     )
    --
   , tmpPartion AS (SELECT Movement.Id
                         , MovementDate_Branch.ValueData AS BranchDate
                         , Movement.Invnumber            AS Invnumber
                         , Object_From.ValueData         AS FromName
                         , Object_Contract.ValueData     AS ContractName
                    FROM Movement
                         LEFT JOIN MovementDate AS MovementDate_Branch
                                                ON MovementDate_Branch.MovementId = Movement.Id
                                               AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                    WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                    )

       SELECT
             MovementItem.Id
           , MovementItem.ParentId  
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , MovementItem.Amount

           , MIFloat_ContainerId.ContainerId                   :: TFloat    AS ContainerId
           , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income
           
           , Object_PartionDateKind.ValueData                  :: TVarChar  AS PartionDateKindName

       FROM tmpMI_Child AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId
                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
            LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIFloat_ContainerId.ContainerId
            LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId
       ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.06.19         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Send_Child(inMovementId := 3959328 ,  inSession := '3');
