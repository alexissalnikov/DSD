-- DROP TABLE IF EXISTS Object_Goods;
/*
CREATE TABLE Object_Goods (
  id                  Integer,   -- ID товара
  ObjectCode          Integer,   -- Код товара
  Name                TVarChar,  -- Название товара

  isErased            Boolean,   -- Признак удален
  isNotUploadSites    Boolean,   -- Не выгружать для сайтов                    (zc_ObjectBoolean_Goods_isNotUploadSites)
  isDoesNotShare      Boolean,   -- Не делить медикамент на кассах (фармацевты)(zc_ObjectBoolean_Goods_DoesNotShare)
  isAllowDivision     Boolean,   -- Разрешить деление товара на кассе          (zc_ObjectBoolean_Goods_AllowDivision)
  isNotTransferTime   Boolean,   -- Не переводить в сроки                      (zc_ObjectBoolean_Goods_NotTransferTime)

  GoodsGroup          integer,   -- Связь товаров с группой товаров           (zc_ObjectLink_Goods_GoodsGroup)
  Measure             integer,   -- Связь товаров с единицей измерения        (zc_ObjectLink_Goods_Measure)
  NDSKind             integer,   -- Связь товаров с Видом НДС                 (ObjectLink_Goods_NDSKind)
  Exchange            integer,   -- Связь товаров с одиницей виміру            (zc_ObjectLink_Goods_Exchange)

  CountPrice          TFloat,    -- Кол-во прайсов                            (zc_ObjectFloat_Goods_CountPrice)

  LastPrice           TDateTime, -- Дата загрузки прайса                      (zc_ObjectDate_Goods_LastPrice)
  LastPriceOld        TDateTime, -- Пред Послед. дата наличия на рынке        (zc_ObjectDate_Goods_LastPriceOld)

  NameUkr             TVarChar,  -- Название украинское                       (zc_ObjectString_Goods_NameUkr)
  CodeUKTZED          TVarChar,  -- Код УКТЗЭД                                (zc_ObjectString_Goods_CodeUKTZED)
  Analog              TVarChar,  -- Перечень аналогов товара                  (zc_ObjectString_Goods_Analog)

   -- Для сайта
  isPublished         Boolean,   -- Опубликован на сайте                       (zc_ObjectBoolean_Goods_Published)
  Site                integer,   -- Ключ товара на сайте                       (zc_ObjectFloat_Goods_Site)

  Foto                TVarChar,  -- Путь к фото                                (zc_ObjectString_Goods_Foto)
  Thumb               TVarChar,  -- Путь к превью фото                         (zc_ObjectString_Goods_Thumb)
  Appointment         integer,   -- Назначение товара                          (zc_ObjectLink_Goods_Appointment)

  Description         TBlob,     -- Описание товара на сайте                   (zc_objectBlob_Goods_Description)
  NameSite            TBlob,     -- Название товара на сайте                   (zc_objectBlob_Goods_Site)

  PRIMARY KEY (id)
);

*/

      WITH GoodsRetail AS (
      SELECT ObjectLink_Main.ChildObjectId                            AS GoodsMainId

           , NULLIF(ObjectString_Goods_NameUkr.ValueData, '')         AS NameUkr
           , NULLIF(ObjectString_Goods_CodeUKTZED.ValueData, '')      AS CodeUKTZED

           , ObjectBoolean_Goods_isNotUploadSites.ValueData           AS isNotUploadSites
           , ObjectBoolean_Goods_DoesNotShare.ValueData               AS DoesNotShare
           , ObjectBoolean_Goods_AllowDivision.ValueData              AS AllowDivision

           , ObjectBoolean_Goods_Published.ValueData                  AS Published
           , ObjectFloat_Goods_Site.ValueData::Integer                AS Site
           , ObjectString_Goods_Foto.ValueData                        AS Foto
           , ObjectString_Goods_Thumb.ValueData                       AS Thumb
           , ObjectLink_Goods_Appointment.ChildObjectId               AS Appointment
/*           , ObjectBlob_Goods_Description.ValueData                   AS Description
           , ObjectBlob_Goods_Site.ValueData                          AS NameSite
*/
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

           LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                  ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

           LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                  ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isNotUploadSites
                                   ON ObjectBoolean_Goods_isNotUploadSites.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_DoesNotShare
                                   ON ObjectBoolean_Goods_DoesNotShare.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_AllowDivision
                                   ON ObjectBoolean_Goods_AllowDivision.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_AllowDivision.DescId = zc_ObjectBoolean_Goods_AllowDivision()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                   ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                  AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()

           LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                 ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()

           LEFT JOIN ObjectString AS ObjectString_Goods_Foto
                                  ON ObjectString_Goods_Foto.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Foto.DescId = zc_ObjectString_Goods_Foto()

           LEFT JOIN ObjectString AS ObjectString_Goods_Thumb
                                  ON ObjectString_Goods_Thumb.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_Thumb.DescId = zc_ObjectString_Goods_Thumb()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()

/*           LEFT JOIN ObjectBlob AS ObjectBlob_Goods_Description
                                ON ObjectBlob_Goods_Description.ObjectId = Object_Goods.Id
                               AND ObjectBlob_Goods_Description.DescId = zc_objectBlob_Goods_Description()
                               AND ObjectBlob_Goods_Description.ValueData Is Not Null

           LEFT JOIN ObjectBlob AS ObjectBlob_Goods_Site
                                ON ObjectBlob_Goods_Site.ObjectId = Object_Goods.Id
                               AND ObjectBlob_Goods_Site.DescId = zc_objectBlob_Goods_Site()
                               AND ObjectBlob_Goods_Site.ValueData Is Not Null
*/
      WHERE Object_Goods.DescId = zc_Object_Goods()
        AND Object_GoodsObject.DescId = zc_Object_Retail()
        AND Object_GoodsObject.ID = 4
     ),
     DoesNotShare AS (
      SELECT DISTINCT
             ObjectLink_Main.ChildObjectId                            AS GoodsMainId

           , True                                                     AS DoesNotShare


      FROM ObjectBoolean AS ObjectBoolean_Goods_DoesNotShare

           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = ObjectBoolean_Goods_DoesNotShare.ObjectId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

      WHERE ObjectBoolean_Goods_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()
        AND ObjectBoolean_Goods_DoesNotShare.ValueData = True
     ),
     NotTransferTime AS (
      SELECT DISTINCT
             ObjectLink_Main.ChildObjectId                            AS GoodsMainId

           , True                                                     AS NotTransferTime


      FROM ObjectBoolean AS ObjectBoolean_Goods_NotTransferTime

           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = ObjectBoolean_Goods_NotTransferTime.ObjectId
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

      WHERE ObjectBoolean_Goods_NotTransferTime.DescId = zc_ObjectBoolean_Goods_NotTransferTime()
        AND ObjectBoolean_Goods_NotTransferTime.ValueData = True
     )


 SELECT
             ObjectBoolean_Goods_isMain.ObjectId              AS Id
           , Object_Goods.ObjectCode                          AS GoodsCode
           , Object_Goods.ValueData                           AS GoodsName
           , Object_Goods.isErased                            AS isErased

           , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
           , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
           , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
           , ObjectLink_Goods_Exchange.ChildObjectId          AS Exchange

           , GoodsRetail.isNotUploadSites                     AS isNotUploadSites
           , DoesNotShare.DoesNotShare                        AS DoesNotShare
           , GoodsRetail.AllowDivision                        AS AllowDivision
           , NotTransferTime.NotTransferTime                  AS NotTransferTime


           , ObjectFloat_Goods_CountPrice.ValueData           AS CountPrice

           , ObjectDate_Goods_LastPrice.ValueData             AS LastPrice
           , ObjectDate_Goods_LastPriceOld.ValueData          AS LastPriceOld

           , GoodsRetail.NameUkr                              AS NameUkr
           , GoodsRetail.CodeUKTZED                           AS CodeUKTZED
           , ObjectString_Goods_Analog.ValueData              AS Analog

           , GoodsRetail.Published                            AS Published
           , GoodsRetail.Site                                 AS Site
           , GoodsRetail.Foto                                 AS Foto
           , GoodsRetail.Thumb                                AS Thumb
           , GoodsRetail.Appointment                          AS Appointment
/*           , GoodsRetail.Description                          AS Description
           , GoodsRetail.NameSite                             AS NameSite
*/
       FROM ObjectBoolean AS ObjectBoolean_Goods_isMain

            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectBoolean_Goods_First()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                 ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                 ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()

            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountPrice
                                  ON ObjectFloat_Goods_CountPrice.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Goods_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()

            LEFT JOIN ObjectDate AS ObjectDate_Goods_LastPrice
                                 ON ObjectDate_Goods_LastPrice.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

            LEFT JOIN ObjectDate AS ObjectDate_Goods_LastPriceOld
                                 ON ObjectDate_Goods_LastPriceOld.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_LastPriceOld.DescId = zc_ObjectDate_Goods_LastPriceOld()

            LEFT JOIN ObjectString AS ObjectString_Goods_Analog
                                   ON ObjectString_Goods_Analog.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Analog.DescId = zc_ObjectString_Goods_Analog()

            LEFT JOIN GoodsRetail ON GoodsRetail.GoodsMainId = ObjectBoolean_Goods_isMain.ObjectId
            LEFT JOIN DoesNotShare ON DoesNotShare.GoodsMainId = ObjectBoolean_Goods_isMain.ObjectId
            LEFT JOIN NotTransferTime ON NotTransferTime.GoodsMainId = ObjectBoolean_Goods_isMain.ObjectId

   WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain();

