-- Function: gpSelect_MovementItem_SendAsset()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendAsset (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendAsset(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , ContainerId Integer
             , Amount TFloat
             , AmountRemains TFloat
             , isErased Boolean
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , Release TDateTime
             , InvNumber TVarChar, SerialNumber TVarChar, PassportNumber TVarChar
             , PeriodUse TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbFromId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������
     SELECT MovementLinkObject_From.ObjectId
            INTO vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

    -- ���������
     RETURN QUERY
       WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , MIFloat_ContainerId.ValueData      :: Integer AS ContainerId
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                   )

          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , SUM (Container.Amount) AS Amount
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                    AND Container.Amount   <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId    = vbFromId
                           GROUP BY tmpMI_Goods.MovementItemId
                          )

       -- ���������
       SELECT
             tmpMI_Goods.MovementItemId         AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Asset_AssetGroup.ValueData         AS GoodsGroupNameFull

           , tmpMI_Goods.ContainerId
           , tmpMI_Goods.Amount                 AS Amount
           , tmpRemains.Amount :: TFloat        AS AmountRemains
           
           , tmpMI_Goods.isErased               AS isErased

           , Object_Maker.Id             AS MakerId
           , Object_Maker.ObjectCode     AS MakerCode
           , Object_Maker.ValueData      AS MakerName

           , Object_Car.Id               AS CarId
           , Object_Car.ObjectCode       AS CarCode
           , Object_Car.ValueData        AS CarName
           , Object_CarModel.ValueData   AS CarModelName
           , COALESCE (ObjectDate_Release.ValueData,CAST (CURRENT_DATE as TDateTime)) AS Release
           , ObjectString_InvNumber.ValueData      AS InvNumber
           , ObjectString_SerialNumber.ValueData   AS SerialNumber
           , ObjectString_PassportNumber.ValueData AS PassportNumber
           , ObjectFloat_PeriodUse.ValueData  AS PeriodUse

       FROM tmpMI_Goods
            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
             
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                                 ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
            LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId

            ---
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Maker
                                 ON ObjectLink_Asset_Maker.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Asset_Maker.DescId = zc_ObjectLink_Asset_Maker()
            LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Asset_Maker.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                 ON ObjectLink_Asset_Car.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Asset_Car.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
  
            LEFT JOIN ObjectDate AS ObjectDate_Release
                                 ON ObjectDate_Release.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectDate_Release.DescId = zc_ObjectDate_Asset_Release()
  
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()
  
            LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                   ON ObjectString_SerialNumber.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_SerialNumber.DescId = zc_ObjectString_Asset_SerialNumber()
  
            LEFT JOIN ObjectString AS ObjectString_PassportNumber
                                   ON ObjectString_PassportNumber.ObjectId = tmpMI_Goods.GoodsId
                                  AND ObjectString_PassportNumber.DescId = zc_ObjectString_Asset_PassportNumber()
  
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodUse
                                  ON ObjectFloat_PeriodUse.ObjectId = tmpMI_Goods.GoodsId
                                 AND ObjectFloat_PeriodUse.DescId = zc_ObjectFloat_Asset_PeriodUse()

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.03.20         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_SendAsset (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_SendAsset (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '2')