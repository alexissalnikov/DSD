-- Function: gpUpdate_Movement_Income_OrderExternalOrdspr 

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_OrderExternal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_OrderExternal (
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inOrderExternalId     Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void 
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbOrderExternalId_old Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);
      
     -- определяем ранее сохраненную заявку
     vbOrderExternalId_old := (SELECT MovementLinkMovement.MovementChildId
                               FROM MovementLinkMovement
                               WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                 AND MovementLinkMovement.MovementId = inId);

     IF (COALESCE (vbOrderExternalId_old,0) <> inOrderExternalId) AND (COALESCE (vbOrderExternalId_old,0) <> 0)
     THEN
         --если меняют на другую заявку то у предыдущей надо возвращать  zc_MovementBoolean_Deferred = TRUE
         -- но если вдруг есть еще приход на этот OrderExternal тогда у заявки Deferred остается как был
         
         --пытаемся найти приход для vbOrderExternalId_old
         --если не находим то меняем zc_MovementBoolean_Deferred = TRUE, иначе не трогаем
         IF NOT EXISTS (SELECT MovementLinkMovement.MovementId 
                        FROM MovementLinkMovement
                        WHERE MovementLinkMovement.descid = zc_MovementLinkMovement_Order()
                          AND MovementLinkMovement.MovementChildId = vbOrderExternalId_old
                          AND MovementLinkMovement.MovementId <> inId)
         THEN
             -- сохранили свойство Отложен = ДА
             PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), vbOrderExternalId_old, TRUE);
             -- сохранили протокол
             PERFORM lpInsert_MovementProtocol (vbOrderExternalId_old, vbUserId, FALSE);
         END IF;

     END IF; 

     -- сохранили связь с <документом заявка поставщику>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inOrderExternalId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.09.19         *
 06.05.16         * 
*/


-- тест
-- SELECT * FROM gpUpdate_Movement_Income_OrderExternal (inId:= 1898475 , inOrderExternalId := 1659212 , inSession:= '5')
