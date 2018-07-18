-- Function: gpGet_PromoCodeReceiving_ForSite()

DROP FUNCTION IF EXISTS gpGet_PromoCodeReceiving_ForSite (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_PromoCodeReceiving_ForSite (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PromoCodeReceiving_ForSite (
    IN inBayerName     TVarChar,   --
    IN inBayerPhone    TVarChar,   --
    IN inBayerEmail    TVarChar,   --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               GUID       TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vCountGUID Integer;
   DECLARE vbIndex Integer;
   DECLARE vbId Integer;
   DECLARE vbGUID TVarChar;
BEGIN
    vbUserId := inSession;

    IF COALESCE (inBayerName, '') = '' OR
       COALESCE (inBayerPhone, '') = ''
    THEN
      RETURN;
    END IF;

    WITH
      tmpMovement AS (
         SELECT
             Movement.Id                                                    AS MovementId
         FROM Movement

            LEFT JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
            LEFT JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

         WHERE Movement.DescId = zc_Movement_PromoCode()
           AND Movement.StatusId = zc_Enum_Status_Complete()
           AND MovementDate_StartPromo.ValueData <= current_date
           AND MovementDate_EndPromo.ValueData >= current_date
           AND COALESCE(MovementBoolean_Electron.ValueData, FALSE) = True
         ORDER BY MovementDate_EndPromo.ValueData LIMIT 1),

      tmpMovementItem AS (SELECT
           M_PromoCode.MovementId,
           MI_PromoCode.ObjectId
         FROM tmpMovement AS M_PromoCode
            INNER JOIN MovementItem AS MI_PromoCode ON MI_PromoCode.MovementId = M_PromoCode.MovementId
                                   AND MI_PromoCode.DescId = zc_MI_Child()
                                   AND MI_PromoCode.isErased = FALSE
                                   AND COALESCE (MI_PromoCode.Amount, 0) = 1
         --WHERE COALESCE (inUnitID, 0) = 0 or MI_PromoCode.ObjectId  = inUnitID
         ),

      tmpMovementFloat AS (SELECT DISTINCT MovementFloat_MovementItemId.MovementId
                                  , MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                             FROM MovementFloat AS MovementFloat_MovementItemId
                             WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId())

    SELECT
      MI_PromoCode.MovementId        AS MovementId,
      MI_Sign.Id                     AS MovementItemID,
      MIString_GUID.ValueData        AS GUID
    INTO
      vbMovementID,
      vbMovementItemID,
      vbGUID
    FROM tmpMovementItem AS MI_PromoCode
            INNER JOIN MovementItem AS MI_Sign ON MI_Sign.MovementId = MI_PromoCode.MovementId
                                   AND MI_Sign.DescId = zc_MI_Sign()
                                   AND MI_Sign.isErased = FALSE

            INNER JOIN MovementItemString AS MIString_GUID
                                          ON MIString_GUID.MovementItemId = MI_Sign.Id
                                         AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN tmpMovementFloat  AS MovementFloat_MovementItemId
                                        ON MovementFloat_MovementItemId.MovementItemId = MI_Sign.Id

            LEFT JOIN MovementItemString AS MIString_Bayer
                                         ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                        AND MIString_Bayer.DescId = zc_MIString_Bayer()

            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = MI_Sign.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

    WHERE COALESCE (MovementFloat_MovementItemId.MovementId, 0) = 0
      AND COALESCE (MIString_Bayer.ValueData, '') = ''
    ORDER BY COALESCE (MIDate_Update.ValueData, ('01.01.2018')::TDateTime), MI_Sign.ID LIMIT 1;

    IF vbMovementItemID IS NOT NULL
    THEN

      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Bayer(), vbMovementItemID, inBayerName);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerPhone(), vbMovementItemID, inBayerPhone);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerEmail(), vbMovementItemID, inBayerEmail);
--      -- сохранили свойство <Примечание>
--      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemID, inComment);
      -- сохранили связь с <>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), vbMovementItemID, vbUserId);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), vbMovementItemID, CURRENT_TIMESTAMP);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (vbMovementItemID, vbUserId, False);

      RETURN QUERY
       SELECT vbGUID;
    END IF;
    
    IF vbMovementID IS NOT NULL THEN
    
      WITH
        tmpMovementFloat AS (SELECT DISTINCT MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                               FROM MovementFloat AS MovementFloat_MovementItemId
                               WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId())

        SELECT Count(*) AS CountGUID
        INTO vCountGUID
           FROM MovementItem AS MI_Sign 

              LEFT JOIN tmpMovementFloat  AS MovementFloat_MovementItemId
                                          ON MovementFloat_MovementItemId.MovementItemId = MI_Sign.Id

              LEFT JOIN MovementItemString AS MIString_Bayer
                                           ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                          AND MIString_Bayer.DescId = zc_MIString_Bayer()

           WHERE MI_Sign.MovementId = vbMovementID
             AND MI_Sign.DescId = zc_MI_Sign()
             AND MI_Sign.isErased = FALSE
             AND COALESCE (MI_Sign.Amount, 0) = 1
             AND COALESCE (MovementFloat_MovementItemId.MovementItemId, 0) = 0
             AND COALESCE (MIString_Bayer.ValueData, '') = '';
           
        IF COALESCE (vCountGUID, 0) < 30 THEN

          vbIndex := 0;
  
          -- строим строчку для кросса
          WHILE (vbIndex < 100) LOOP
            vbIndex := vbIndex + 1;
      
            -- сохранили <Элемент документа>
            INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (zc_MI_Sign(), Null, vbMovementID, 1, NULL) RETURNING Id INTO vbId;          

            -- генерируем новый GUID код
            vbGUID := (SELECT zfCalc_GUID());

            -- сохранили свойство <>
            PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
  
            -- сохранили связь с <>
            PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);
            -- сохранили свойство <>
            PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);

          END LOOP;
        END IF;
      END IF;
      
    
END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 14.06.18        *
*/

-- select * from gpGet_PromoCodeReceiving_ForSite('gdfghdfhdfh', '6575487568', '', zfCalc_UserSite());