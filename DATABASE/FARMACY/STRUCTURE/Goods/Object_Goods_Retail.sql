-- DROP TABLE IF EXISTS Object_Goods_Retail;
/*
CREATE TABLE Object_Goods_Retail (
  Id                  Serial,    -- Id
  GoodsMainId         integer,   -- Связь товаров с главным товаром
  RetailId            integer,   -- Связь товаров с торговой сетью

  isErased            Boolean,   -- Признак удален

  MinimumLot          TFloat,    -- Минимальная партия           (zc_ObjectFloat_Goods_MinimumLot)
  PercentMarkup       TFloat,    -- % наценки                                  (zc_ObjectFloat_Goods_PercentMarkup)
  Price               TFloat,    -- цена реализации                            (zc_ObjectFloat_Goods_Price)

  isTOP               Boolean,   -- ТОП - позиция                              (zc_ObjectBoolean_Goods_TOP)
  isFirst             Boolean,   -- 1-выбор                                    (zc_ObjectBoolean_Goods_First)
  isSecond            Boolean,   -- Неприоритетный выбор                       (zc_ObjectBoolean_Goods_Second)

  UserInsertId        Integer,   -- Пользователь (создание)                    (zc_ObjectLink_Protocol_Insert)
  UserUpdateId        Integer,   -- Пользователь (корректировка)               (zc_ObjectLink_Protocol_Update)
  DateInsert          TDateTime, -- Дата создания                              (zc_ObjectDate_Protocol_Insert)
  DateUpdate          TDateTime, -- Дата корректировки                         (Update zc_ObjectDate_Protocol_Update)

  CONSTRAINT Object_Goods_Retail_pkey PRIMARY KEY(Id)
);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Retail_Id_GoodsMainId ON public.Object_Goods_Retail
  USING btree (Id, GoodsMainId);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Retail_GoodsMainId_RetailId ON public.Object_Goods_Retail
  USING btree (GoodsMainId, RetailId);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Retail_RetailId_GoodsMainId ON public.Object_Goods_Retail
  USING btree (RetailId, GoodsMainId);

CREATE INDEX IF NOT EXISTS idx_Object_Goods_Retail_RetailId ON public.Object_Goods_Retail
  USING btree (RetailId);

SELECT * FROM Object_Goods_Retail
LIMIT 1000
*/

--INSERT INTO Object_Goods_Retail

   SELECT
             Object_Goods.Id
           , ObjectLink_Main.ChildObjectId                    AS GoodsMainId
           , ObjectLink_Goods_Object.ChildObjectId            AS RetailId

           , Object_Goods.isErased

           , ObjectFloat_Goods_MinimumLot.ValueData           AS MinimumLot
           , ObjectFloat_Goods_PercentMarkup.ValueData        AS PercentMarkup   --- 64
           , ObjectFloat_Goods_Price.ValueData                AS Price           --- 64

           , ObjectBoolean_Goods_TOP.ValueData                AS TOP             ---
           , ObjectBoolean_Goods_First.ValueData              AS First
           , ObjectBoolean_Goods_Second.ValueData             AS Second          --- 87

           , ObjectLink_Protocol_Insert.ChildObjectId         AS UserInsert
           , ObjectLink_Protocol_Update.ChildObjectId         AS UserUpdate
           , ObjectDate_Protocol_Insert.ValueData             AS DateInsert
           , ObjectDate_Protocol_Update.ValueData             AS DateUpdate

    FROM Object AS Object_Goods

         -- получается GoodsMainId
         LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                  AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
         LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
         LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
         LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                               ON ObjectFloat_Goods_PercentMarkup.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                               ON ObjectFloat_Goods_Price.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                 ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                 ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                 ON ObjectBoolean_Goods_Second.ObjectId = Object_Goods.Id
                                AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second()

         LEFT JOIN ObjectLink AS ObjectLink_Protocol_Insert
                              ON ObjectLink_Protocol_Insert.ObjectId = Object_Goods.Id
                             AND ObjectLink_Protocol_Insert.DescId = zc_ObjectLink_Protocol_Insert()

         LEFT JOIN ObjectLink AS ObjectLink_Protocol_Update
                              ON ObjectLink_Protocol_Update.ObjectId = Object_Goods.Id
                             AND ObjectLink_Protocol_Update.DescId = zc_ObjectLink_Protocol_Update()

         LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                              ON ObjectDate_Protocol_Insert.ObjectId = Object_Goods.Id
                             AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()

         LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                              ON ObjectDate_Protocol_Update.ObjectId = Object_Goods.Id
                             AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

         LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                               ON ObjectFloat_Goods_MinimumLot.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()

    WHERE Object_Goods.DescId = zc_Object_Goods()
      AND Object_GoodsObject.DescId = zc_Object_Retail()
--      AND Object_GoodsObject.ID = 4
--      AND Object_Goods.Id = 1024992
--     AND ObjectFloat_Goods_MinimumLot.ValueData <> 0
    ORDER BY Object_Goods.Id
--    LIMIT 1000
   ;
