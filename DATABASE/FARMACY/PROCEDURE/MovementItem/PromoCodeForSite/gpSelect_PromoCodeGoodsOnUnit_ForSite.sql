-- Function: gpSelect_PromoCodeGoodsOnUnit_ForSite()

DROP FUNCTION IF EXISTS gpSelect_PromoCodeGoodsOnUnit_ForSite (Integer, TVarChar, Text, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_PromoCodeGoodsOnUnit_ForSite (Text, TVarChar, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoCodeGoodsOnUnit_ForSite(
    IN inUnitId_list      Text,   -- Список подразделений, через зпт
    IN inGUID             TVarChar,   -- Промо код
    IN inGoodsId_list     Text,       -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId                Integer
             , Id                Integer
             , Article           Integer
             , Id_Site           Integer
             , Name_Site         TBlob
             , Name              TVarChar
             , Remains           TFloat    -- Остаток (с учетом резерва)
             , RemainsAll        TFloat    -- Остаток (без учета резерва)
             , AmountDeferred    TFloat    -- резерв

             , Price_unit        TFloat    -- цена аптеки
             , ChangePercent     TFloat    -- Процент скидки
             , ChangePrice       TFloat    -- Цена со скидкой
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbIndex Integer;

   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- Определяем акцию и код промокода
    SELECT
      MovementID,
      MovementItemID
    INTO
      vbMovementID,
      vbMovementItemID
    FROM gpGet_PromoCodeUnitToID_ForSite(0, inGUID, True, inSession);

    IF vbMovementItemID IS NULL
    THEN
      RETURN;
    END IF;


    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunitminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer, AreaId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnitMinPrice_List (UnitId, AreaId)
           SELECT tmp.UnitId
                , COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) AS AreaId
           FROM (SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer AS UnitId
                ) AS tmp
                LEFT JOIN ObjectLink AS OL_Unit_Area
                                     ON OL_Unit_Area.ObjectId = tmp.UnitId
                                    AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;

    -- парсим товары
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           SELECT tmp.GoodsId
                , ObjectLink_Child_ALL.ChildObjectId AS GoodsId_retail
           FROM (SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer AS GoodsId
                ) AS tmp
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                                                                 AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                    INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                                      AND Object_Retail.DescId = zc_Object_Retail()
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;


    -- !!!Оптимизация!!!
    ANALYZE _tmpUnitMinPrice_List;

    -- если нет товаров
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List WHERE GoodsId <> 0)
    THEN
         -- все остатки учачтвующие в акции
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)

         WITH
         tmpGoods AS (SELECT
                MI_PromoCode.ObjectId     AS GoodsId
           FROM MovementItem AS MI_PromoCode
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoCode.ObjectId

                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MI_PromoCode.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()
           WHERE MI_PromoCode.MovementId = vbMovementID
             AND MI_PromoCode.DescId = zc_MI_Master()
             AND MI_PromoCode.isErased = FALSE
             AND MI_PromoCode.Amount = 1)

           SELECT tmp.GoodsId
                , ObjectLink_Child_ALL.ChildObjectId AS GoodsId_retail
           FROM tmpGoods AS tmp
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                                                                 AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                    INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                                      AND Object_Retail.DescId = zc_Object_Retail()
          ;
    END IF;


    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- еще оптимизируем - _tmpContainerCount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCount'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpContainerCount (UnitId Integer, GoodsId Integer, GoodsId_retail Integer, Amount TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCount;
    END IF;
    --
    INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
                WITH tmpContainer AS
               (SELECT Container.WhereObjectId                AS UnitId
                     , _tmpGoodsMinPrice_List.GoodsId         AS GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail  AS GoodsId_retail
                     , SUM (Container.Amount)                 AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                         AND Container.DescId   = zc_Container_Count()
                                         AND Container.Amount   <> 0
                                         AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)


                GROUP BY Container.WhereObjectId
                       , _tmpGoodsMinPrice_List.GoodsId
                       , _tmpGoodsMinPrice_List.GoodsId_retail
                HAVING SUM (Container.Amount) > 0
               )
                -- результат
                SELECT tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.GoodsId_retail
                     , tmpContainer.Amount
                FROM tmpContainer
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpContainer.UnitId
               ;

    -- !!!Оптимизация!!!
    ANALYZE _tmpContainerCount;

    -- еще оптимизируем - _tmpList
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpList'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpList (UnitId Integer, AreaId Integer, GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpList;
    END IF;
    --
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail)
                -- SELECT DISTINCT _tmpContainerCount.UnitId, _tmpContainerCount.GoodsId, _tmpContainerCount.GoodsId_retail FROM _tmpContainerCount;
                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , ObjectLink_Child_R.ChildObjectId AS GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     LEFT JOIN _tmpUnitMinPrice_List ON 1=1
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = _tmpUnitMinPrice_List.UnitId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = _tmpGoodsMinPrice_List.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                              AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                               AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_R.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                ;
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail)
                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId AS GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     LEFT JOIN _tmpUnitMinPrice_List ON 1=1
                     LEFT JOIN _tmpList ON _tmpList.UnitId = _tmpUnitMinPrice_List.UnitId
                                       AND _tmpList.GoodsId = _tmpGoodsMinPrice_List.GoodsId
                WHERE _tmpList.GoodsId IS NULL;


    -- !!!Оптимизация!!!
    ANALYZE _tmpList;


    -- Результат
    RETURN QUERY
       WITH tmpMI_Deferred AS
               (SELECT tmpList.UnitId
                     , MovementItem.ObjectId     AS GoodsId
                     , SUM (MovementItem.Amount) AS Amount
                FROM _tmpUnitMinPrice_List AS tmpList
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.ObjectId = tmpList.UnitId
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                ON MovementBoolean_Deferred.MovementId = MovementLinkObject_Unit.MovementId
                                               AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                               AND MovementBoolean_Deferred.ValueData = TRUE
                     INNER JOIN Movement ON Movement.Id       = MovementLinkObject_Unit.MovementId
                                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                        AND Movement.DescId   = zc_Movement_Check()
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = FALSE
                     -- INNER JOIN _tmpGoodsMinPrice_List ON _tmpGoodsMinPrice_List.GoodsId = MovementItem.ObjectId
                GROUP BY tmpList.UnitId
                       , MovementItem.ObjectId
               )
          , Price_Unit_all AS
               (SELECT _tmpList.UnitId
                     , _tmpList.GoodsId
                     , ObjectFloat_Price_Value.ValueData AS Price
                -- FROM _tmpGoodsMinPrice_List
                FROM _tmpList
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpList.GoodsId_retail -- _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = _tmpList.UnitId
                     -- INNER JOIN _tmpUnitMinPrice_List AS tmpList ON tmpList.UnitId = ObjectLink_Price_Unit.ChildObjectId
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
               )
          , Price_Unit AS
               (SELECT Price_Unit_all.UnitId
                     , Price_Unit_all.GoodsId
                     , ROUND (Price_Unit_all.Price, 2) :: TFloat AS Price
                FROM Price_Unit_all
               )
          , Goods_PromoCode AS
               (SELECT DISTINCT MI_PromoCode.ObjectId     AS GoodsId
                FROM MovementItem AS MI_PromoCode
                      INNER JOIN _tmpGoodsMinPrice_List ON _tmpGoodsMinPrice_List.GoodsId = MI_PromoCode.ObjectId

                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoCode.ObjectId

                      LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MI_PromoCode.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                WHERE MI_PromoCode.MovementId = vbMovementID
                  AND MI_PromoCode.DescId = zc_MI_Master()
                  AND MI_PromoCode.isErased = FALSE
                  AND MI_PromoCode.Amount = 1)
          , Goods_ChangePercent AS
               (SELECT COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent
                FROM MovementFloat AS MovementFloat_ChangePercent
                WHERE MovementFloat_ChangePercent.MovementId =  vbMovementID
                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent())



        SELECT Object_Unit.Id                                          AS UnitId
--             , Object_Unit.ValueData                                   AS UnitName
             , Object_Goods.Id                             AS Id
             , Object_Goods.ObjectCode                     AS Article
             , ObjectFloat_Goods_Site.ValueData :: Integer AS Id_Site
             , ObjectBlob_Site.ValueData                   AS Name_Site
             , Object_Goods.ValueData                      AS Name

             , (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0)) :: TFloat AS Remains
             , tmpList2.Amount                                         :: TFloat AS RemainsAll
             , tmpMI_Deferred.Amount                                   :: TFloat AS AmountDeferred

             , Price_Unit.Price                                                                      AS Price_unit
             , CASE WHEN Goods_PromoCode.GoodsId IS NOT NULL THEN
                 COALESCE(Goods_ChangePercent.ChangePercent, 0) ELSE 0 END::TFloat                   AS ChangePercent
             , ROUND(Price_Unit.Price * (100.0 - CASE WHEN Goods_PromoCode.GoodsId IS NOT NULL THEN
                 COALESCE(Goods_ChangePercent.ChangePercent, 0) ELSE 0 END) / 100.0, 2)::TFloat      AS ChangePrice

        FROM _tmpList AS tmpList

             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpList.UnitId AND Object_Unit.DescId = zc_Object_Unit()
             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId

             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                   ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()

             LEFT JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()

             LEFT JOIN tmpMI_Deferred ON tmpMI_Deferred.GoodsId = tmpList.GoodsId_retail
                                     AND tmpMI_Deferred.UnitId  = tmpList.UnitId

             LEFT JOIN Price_Unit     ON Price_Unit.GoodsId     = tmpList.GoodsId
                                     AND Price_Unit.UnitId      = tmpList.UnitId
             LEFT JOIN _tmpContainerCount AS tmpList2
                                          ON tmpList2.GoodsId = tmpList.GoodsId
                                         AND tmpList2.UnitId  = tmpList.UnitId

             LEFT JOIN Goods_PromoCode ON Goods_PromoCode.GoodsId = Object_Goods.Id
             LEFT JOIN Goods_ChangePercent ON 1 = 1

      ORDER BY Price_Unit.Price;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.06.18        *
*/

-- тест
-- SELECT * FROM gpSelect_PromoCodeGoodsOnUnit_ForSite (183292, '6b76a687', '', zfCalc_UserSite()) ORDER BY 1;
-- SELECT * FROM gpSelect_PromoCodeGoodsOnUnit_ForSite ('377613,183292', '6b76a687', '331,346,373,951,16876,40618', zfCalc_UserSite()) ORDER BY 1;