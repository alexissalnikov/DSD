-- Function: gpGet_MovementItem_WagesUser()

DROP FUNCTION IF EXISTS gpGet_MovementItem_WagesUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_WagesUser(
    IN inOperDate    TDateTime      , -- ���� ���������
    IN inSession     TVarChar         -- ������ ������������
)
RETURNS TABLE (Id Integer, UserID Integer, AmountAccrued TFloat
             , AmountCard TFloat, AmountHand TFloat
             , MemberCode Integer, MemberName TVarChar, PositionName TVarChar
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , OperDate TDateTime
              )
AS
$BODY$
    DECLARE vbUserId     Integer;
    DECLARE vbMovementId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    inOperDate := date_trunc('month', inOperDate);
    
    IF vbUserId = 3
    THEN
      vbUserId  := 7579515;
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Wages())
    THEN
      SELECT Movement.ID
      INTO vbMovementId  
      FROM Movement 
      WHERE Movement.OperDate = inOperDate 
        AND Movement.DescId = zc_Movement_Wages();
    ELSE 
       RAISE EXCEPTION '�� ������ ������ �.�. �� %', to_char(inOperDate, 'dd.mm.yyyy');
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem 
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.ObjectId = vbUserId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE)
    THEN
        RETURN QUERY
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                          , Object_Personal_View.UnitId         AS UnitId
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User())

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS AmountAccrued
                 
                 , MIF_AmountCard.ValueData           AS AmountCard
                 , (MovementItem.Amount - COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , inOperDate::TDateTime              AS OperDate
            FROM  MovementItem

                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, MovementItem.ObjectId) =  MovementItem.ObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Personal_View.UnitID

                  LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                              ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                             AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

            WHERE MovementItem.MovementId = vbMovementId
              AND MovementItem.ObjectId = vbUserId
              AND MovementItem.DescId = zc_MI_Master()
              AND MovementItem.isErased = FALSE;
    ELSE 
       RAISE EXCEPTION '�� ������ �� ��� ������ �.�. �� %', to_char(inOperDate, 'dd.mm.yyyy');
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.08.19                                                        *
*/
-- select * from gpGet_MovementItem_WagesUser(inOperDate := '01.08.2019',  inSession := '3');