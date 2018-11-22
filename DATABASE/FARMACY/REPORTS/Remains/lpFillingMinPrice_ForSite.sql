-- Function: lpFillingMinPrice_ForSiteNew()

DROP FUNCTION IF EXISTS lpFillingMinPrice_ForSite ();

CREATE OR REPLACE FUNCTION lpFillingMinPrice_ForSite()

RETURNS VOID
AS
$BODY$
  DECLARE inUnitId    Integer;
  DECLARE inObjectId  Integer;
  DECLARE inUserId    Integer;
BEGIN

    -- ����� � ������ "������� �� ����"
    -- SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

  inUnitId := 0;
  inObjectId := 4 ;
  inUserId := zfCalc_UserSite()::Integer;

  CREATE TABLE MinPrice_ForSite_Temp
  (
    GoodsId            Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    PartionGoodsDate   TDateTime,
    Partner_GoodsId    Integer,
    Partner_GoodsCode  TVarChar,
    Partner_GoodsName  TVarChar,
    MakerName          TVarChar,
    ContractId         Integer,
    AreaId             Integer,
    JuridicalId        Integer,
    JuridicalName      TVarChar,
    Price              TFloat,
    SuperFinalPrice    TFloat,
    isTop              Boolean,
    isOneJuridical     Boolean
  );


  CREATE TEMP TABLE tmpGoodsList
  (
     GoodsId Integer,
     GoodsId_main Integer, 
     GoodsId_jur Integer, 
     ObjectId Integer, 
     PRIMARY KEY (GoodsId_jur, GoodsId, GoodsId_main, ObjectId)
  ) ON COMMIT DROP;


  INSERT INTO tmpGoodsList
  WITH
    -- ������ ������� + ���� ...
    -- ������ ������� + ���� ...
    GoodsList_Retal AS (SELECT
                               Object_Goods_View.Id    AS GoodsId
                        FROM Object AS Object_Retail
                             INNER JOIN Object_Goods_View ON Object_Goods_View.ObjectId = Object_Retail.Id
                        WHERE Object_Retail.DescId = zc_Object_Retail()
                          AND Object_Goods_View.isErased = False
                          --AND COALESCE (Object_Goods_View.isPublished, False) = True
                         )
  , GoodsList_all AS
       (SELECT GoodsList_Retal.GoodsId               AS GoodsId      -- ����� ����� "����"
             , ObjectLink_LinkGoods_Main.ChildObjectId      AS GoodsId_main -- ����� "�����" �����
             , ObjectLink_LinkGoods_Child_jur.ChildObjectId AS GoodsId_jur  -- ����� ����� "����������"
             , ObjectLink_Goods_Object_jur.ChildObjectId    AS ObjectId     -- ����� ��� ������ - � ��.����(����������) � ���� � �.�.
        FROM GoodsList_Retal
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child
                                  ON ObjectLink_LinkGoods_Child.ChildObjectId = GoodsList_Retal.GoodsId
                                 AND ObjectLink_LinkGoods_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main
                                  ON ObjectLink_LinkGoods_Main.ObjectId = ObjectLink_LinkGoods_Child.ObjectId
                                 AND ObjectLink_LinkGoods_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()

            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main_jur
                                  ON ObjectLink_LinkGoods_Main_jur.ChildObjectId = ObjectLink_LinkGoods_Main.ChildObjectId
                                 AND ObjectLink_LinkGoods_Main_jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child_jur
                                  ON ObjectLink_LinkGoods_Child_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                 AND ObjectLink_LinkGoods_Child_jur.DescId = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                  ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_Child_jur.ChildObjectId
                                 AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()
       )
    -- ������ ������� + ���� ...

       (SELECT DISTINCT GoodsList_all.*
        FROM GoodsList_all
             INNER JOIN Object ON Object.Id = GoodsList_all.ObjectId
                              AND Object.DescId = zc_Object_Juridical()
       );
       
  ANALYSE tmpGoodsList;

  -- ���������
  INSERT INTO MinPrice_ForSite_Temp
  WITH
    -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����) !!!������ ���� ������������ ObjectId!!!
    PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
  , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar))
    -- ��������� ��� ��. ��� (��� ���������� ������������ ������� � �.�) !!!��� ���� MainJuridicalId!!!
  , JuridicalSettings_all AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus, tmp.isPriceClose, tmp.isSite
                              FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS tmp
                              WHERE tmp.isSite = TRUE -- ��� �����: � ������� ����� ��������� � �������� ���� ��� ������ �� �����, ����� ���� ������ ���� ��������� � �����������
                              -- WHERE tmp.MainJuridicalId = vbMainJuridicalId
                             )
  /*, JuridicalSettings_close AS (SELECT DISTINCT tmp.JuridicalId, tmp.ContractId
                                FROM JuridicalSettings_all AS tmp
                                WHERE tmp.isPriceClose = TRUE
                               )*/
  , JuridicalSettings_new AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus
                                   , ROW_NUMBER() OVER (PARTITION BY tmp.JuridicalId ORDER BY tmp.JuridicalId, CASE WHEN tmp.isSite = TRUE THEN 0 ELSE 1 END, tmp.ContractId) AS Ord
                              FROM JuridicalSettings_all AS tmp
                              -- ��� ����� �����������
                              -- WHERE tmp.isPriceClose = FALSE -- �����, �.�. tmp.isSite = TRUE
                             )
    -- ������������� ��������
  , GoodsPromo AS (SELECT 0 AS JuridicalId
                        , 0 AS GoodsId        -- ����� ����� "����"
                        , 0 AS ChangePercent
                   /*SELECT tmp.JuridicalId
                        , tmp.GoodsId        -- ����� ����� "����"
                        , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp*/
                  )

    -- �������� � ������ ������� ��� ��� ��� �����
  , JuridicalSettings AS (SELECT tmp.JuridicalId, tmp.ContractId, tmp.PriceLimit, tmp.Bonus
                          FROM JuridicalSettings_new AS tmp
                          -- !!!���� �������� ����. - ����� ����� ��� ���� ���������!!!
                          WHERE tmp.Ord = 1
                         )
  , JuridicalSettings_list AS (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId, JuridicalSettings.PriceLimit, JuridicalSettings.Bonus FROM JuridicalSettings)
    -- ������ ���� + ���
  ,  GoodsPrice AS
       (SELECT GoodsList.GoodsId, ObjectBoolean_Top.ValueData AS isTOP
        FROM tmpGoodsList AS GoodsList
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   ON ObjectLink_Price_Goods.ChildObjectId = GoodsList.GoodsId
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                      ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                     AND ObjectBoolean_Top.ValueData = TRUE
       )
    -- ������ ��������� ��� (����������) !!!�� ����������!!! (�.�. ��������� �������� � �� ��������� ��������� ����)
  , Movement_PriceList_all AS
       (-- ���������� ��� !!!�� ������ "ObjectId"!!!
        SELECT Movement.OperDate
             , Movement.Id                                        AS MovementId
             , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
             , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MovementLinkObject_Area.ObjectId, zc_Area_Basis()) AS AreaId
             , COALESCE (JuridicalSettings_list.PriceLimit, 0)    AS PriceLimit
             , COALESCE (JuridicalSettings_list.Bonus, 0)         AS Bonus
        FROM (SELECT DISTINCT ObjectId FROM tmpGoodsList) AS tmp
             INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.ObjectId = tmp.ObjectId
                                          AND MovementLinkObject_Juridical.DescId   = zc_MovementLinkObject_Juridical()
             INNER JOIN Movement ON Movement.Id     = MovementLinkObject_Juridical.MovementId
                                AND Movement.DescId = zc_Movement_PriceList()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                          ON MovementLinkObject_Area.MovementId = Movement.Id
                                         AND MovementLinkObject_Area.DescId     = zc_MovementLinkObject_Area()
             INNER JOIN JuridicalSettings_list ON JuridicalSettings_list.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                              AND JuridicalSettings_list.ContractId  = MovementLinkObject_Contract.ObjectId
        WHERE Movement.DescId   = zc_Movement_PriceList()
          AND Movement.StatusId <> zc_Enum_Status_Erased()
       )
    -- ������ ��������� ��� (����������) !!!�� ����������!!! (�.�. ��������� �������� � �� ��������� ��������� ����)
  , Movement_PriceList AS
       /*(-- ���������� � "������" ��������� �� JuridicalSettings
        SELECT tmp.MovementId
             , tmp.JuridicalId
             , tmp.ContractId
             --, COALESCE (JuridicalSettings.PriceLimit, 0) AS PriceLimit
             --, COALESCE (JuridicalSettings.Bonus, 0)      AS Bonus
             , tmp.PriceLimit
             , tmp.Bonus
        FROM*/
       (-- ���������� � "����" �����
        SELECT *
        FROM
       (-- ���������� ��� !!!�� ������ "ObjectId"!!!
        SELECT --  � �/�
               ROW_NUMBER() OVER (PARTITION BY Movement_PriceList_all.AreaId, Movement_PriceList_all.JuridicalId, Movement_PriceList_all.ContractId ORDER BY Movement_PriceList_all.OperDate DESC) AS Ord
             , Movement_PriceList_all.OperDate
             , Movement_PriceList_all.MovementId
             , Movement_PriceList_all.JuridicalId
             , Movement_PriceList_all.ContractId
             , Movement_PriceList_all.AreaId
             , Movement_PriceList_all.PriceLimit
             , Movement_PriceList_all.Bonus
        FROM Movement_PriceList_all
       ) AS tmp
        WHERE tmp.Ord = 1 -- �.�. ��� �������� � �� ���� ����� 1 ��������
       ) /*AS tmp*/
        -- !!!INNER!!!
        /*INNER JOIN JuridicalSettings_list AS JuridicalSettings ON JuridicalSettings.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings.ContractId  = tmp.ContractId*/
        /*LEFT JOIN JuridicalSettings_close ON JuridicalSettings_close.JuridicalId = tmp.JuridicalId
                                         AND JuridicalSettings_close.ContractId  = tmp.ContractId */

        /*WHERE COALESCE (JuridicalSettings.ContractId, tmp.ContractId) = tmp.ContractId -- �.�. ���� ���� �� ���� � JuridicalSettings, ����� Movement � !!!����� ��!!! ContractId, ����� - !!!���!! Movement
          AND JuridicalSettings_close.JuridicalId IS NULL -- !!!�.�. �� ������!!!
        */
       /*)*/
    -- ��������� ���� (����������) �� "������" ������� �� GoodsList
  , MI_PriceList AS
       (SELECT Movement_PriceList.MovementId
             , Movement_PriceList.JuridicalId
             , Movement_PriceList.ContractId
             , Movement_PriceList.AreaId
             , Movement_PriceList.PriceLimit
             , Movement_PriceList.Bonus
             , MovementItem.Id     AS MovementItemId
             , MovementItem.Amount AS Price
             , GoodsList.GoodsId      -- ����� ����� "����"
             , GoodsList.GoodsId_main -- ����� "�����" �����
             , GoodsList.GoodsId_jur  -- ����� ����� "����������"
             , GoodsList.ObjectId     -- ����� �� ���� ���� ����� ��� � � Movement_PriceList.JuridicalId
        FROM Movement_PriceList
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PriceList.MovementId
             INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                              AND MILinkObject_Goods.ObjectId      IN (SELECT DISTINCT tmpGoodsList.GoodsId_jur FROM tmpGoodsList) -- ����� "����������"
             LEFT JOIN tmpGoodsList AS GoodsList 
                                    ON GoodsList.GoodsId_jur = MILinkObject_Goods.ObjectId -- ����� "����������"
       )

    -- ����� ��������� ������
  , FinalList AS
       (SELECT
        ddd.GoodsId
      , ddd.GoodsCode
      , ddd.GoodsName
      , ddd.Price
      , ddd.PartionGoodsDate
      , ddd.Partner_GoodsId
      , ddd.Partner_GoodsCode
      , ddd.Partner_GoodsName
      , ddd.MakerName
      , ddd.ContractId
      , ddd.AreaId
      , ddd.JuridicalId
      , ddd.JuridicalName
      , ddd.Deferment
      , ddd.PriceListMovementItemId
/* * /
      , CASE -- ���� ���� �������� �� �������� = 0
             WHEN ddd.Deferment = 0
                  THEN FinalPrice
             -- ���� ���-�������
             WHEN ddd.isTOP = TRUE
                  THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- ����� ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             ELSE FinalPrice * (100 - PriceSettings.Percent) / 100

        END :: TFloat AS SuperFinalPrice
/ */
      , CASE -- ���� ���� �������� �� �������� = 0 + ���-������� ��������� % �� ... (��� � ������������ ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                  THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- ���� ���� �������� �� �������� = 0 + �� ���-������� = ��������� % �� ��������� ��� ������� ����� (��� � ������������ ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                  THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
             -- ����� �� ���������
             ELSE FinalPrice

        END :: TFloat AS SuperFinalPrice
/* */
      , ddd.isTOP

    FROM (SELECT DISTINCT
            -- ����� "����"
            MI_PriceList.GoodsId               AS GoodsId
          , Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName

            -- ������ ���� ����������
          , MI_PriceList.Price
            -- ����������� ���� ���������� - ��� ������ "����"
          , MIN (MI_PriceList.Price) OVER (PARTITION BY MI_PriceList.GoodsId) AS MinPrice
          , MI_PriceList.MovementItemId        AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- ���� ���� ���������� >= PriceLimit (�� ����� ���� ��������� ����� ��� ������� �����. ����)
                 WHEN COALESCE (MI_PriceList.PriceLimit, 0) <= MI_PriceList.Price
                    THEN MI_PriceList.Price
                         -- ����������� % ������ �� ������������� ��������
                       * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                 ELSE -- ����� ����������� ����� - ��� ���-������� ��� �� ���-�������
                      (MI_PriceList.Price * (100 - COALESCE (MI_PriceList.Bonus, 0)) / 100)
                      -- � ����������� % ������ �� ������������� ��������
                    * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
            END :: TFloat AS FinalPrice

          , MI_PriceList.GoodsId_jur           AS Partner_GoodsId
          , ObjectString_Goods_Code.ValueData  AS Partner_GoodsCode
          , Object_Goods_jur_mi.ValueData      AS Partner_GoodsName
          , ObjectString_Goods_Maker.ValueData AS MakerName
          , MI_PriceList.ContractId            AS ContractId
          , MI_PriceList.AreaId                AS AreaId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP

        FROM -- ��������� ���� (����������) �� "������" ������� �� GoodsList
             MI_PriceList
             -- ���� ������ ������ (��� ���� ��������?) � �����-���� (����������)
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId =  MI_PriceList.MovementItemId
                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            -- ����� "����������", � �� ���� � �������
            LEFT JOIN Object AS Object_Goods_jur_mi ON Object_Goods_jur_mi.Id = MI_PriceList.GoodsId_jur
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                   ON ObjectString_Goods_Maker.ObjectId = Object_Goods_jur_mi.Id
                                  AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()
            LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                   ON ObjectString_Goods_Code.ObjectId = Object_Goods_jur_mi.Id
                                  AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()
            -- ����� "����"
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PriceList.GoodsId
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods.Id
            -- ���������
            INNER JOIN Object AS Juridical ON Juridical.Id = MI_PriceList.JuridicalId -- ???���� ����� ��� � ObjectId???

            -- ���� �������� �� ��������
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                  ON ObjectFloat_Deferment.ObjectId = MI_PriceList.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
            -- % ������ �� ������������� ��������
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MI_PriceList.GoodsId
                                AND GoodsPromo.JuridicalId = MI_PriceList.JuridicalId
       ) AS ddd
       -- ��������� ��� ������� ����� (���� ����� � ��������� - ����� ���� ������� �������������� ������ � ������� �� �����)
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
   )

    -- ������������� �� ���� + ���� �������� � �������� �������
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId, FinalList.AreaId ORDER BY FinalList.SuperFinalPrice ASC, FinalList.Deferment DESC, FinalList.PriceListMovementItemId ASC) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )
    -- ������� ����������� � ������
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, FinalList.AreaId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId, FinalList.AreaId
                         )
    -- ���������
    SELECT
        MinPriceList.GoodsId,
        MinPriceList.GoodsCode,
        MinPriceList.GoodsName,
        MinPriceList.PartionGoodsDate,
        MinPriceList.Partner_GoodsId,
        MinPriceList.Partner_GoodsCode,
        MinPriceList.Partner_GoodsName,
        MinPriceList.MakerName,
        MinPriceList.ContractId,
        MinPriceList.AreaId,
        MinPriceList.JuridicalId,
        MinPriceList.JuridicalName,
        MinPriceList.Price,
        MinPriceList.SuperFinalPrice,
        MinPriceList.isTop,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOneJuridical
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
                                    AND tmpCountJuridical.AreaId  = MinPriceList.AreaId;

  DROP TABLE IF EXISTS MinPrice_ForSite;
  ALTER TABLE MinPrice_ForSite_Temp RENAME TO MinPrice_ForSite;
  ALTER TABLE MinPrice_ForSite OWNER TO postgres;
  CREATE INDEX idx_MinPrice_ForSite_GoodsId ON MinPrice_ForSite(GoodsId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpFillingMinPrice_ForSite () OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 15.04.16                                        *
*/

-- ����
-- SELECT * FROM lpFillingMinPrice_ForSite ()
-- SELECT Count(*) FROM MinPrice_ForSite
