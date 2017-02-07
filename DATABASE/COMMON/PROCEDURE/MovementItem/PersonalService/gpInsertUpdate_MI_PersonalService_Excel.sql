-- Function: gpInsertUpdate_MI_PersonalService_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Excel (Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Excel(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inINN                 TVarChar  , -- ���
    IN inFIO                 TVarChar  , -- ���
    IN inSummNalogRecalc     TFloat    , -- ����� ������ - ��������� � �� ��� �������������
    IN inSummCardRecalc1     TFloat    , -- �����1 �� �������� (��) ��� �������������
    IN inSummCardRecalc2     TFloat    , -- �����2 �� �������� (��) ��� �������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     -- ������
     inINN:= TRIM (inINN);

     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������';
     END IF;

     -- ��������
     IF inINN = '' AND inFIO = '' AND COALESCE (inSummNalogRecalc, 0) = 0 AND COALESCE (inSummCardRecalc1, 0) = 0 AND COALESCE (inSummCardRecalc2, 0) = 0
     THEN
         RETURN;
     END IF;
     -- ��������
     IF inINN = '-' AND inFIO = '-' AND COALESCE (inSummNalogRecalc, 0) = 0 AND COALESCE (inSummCardRecalc1, 0) = 0 AND COALESCE (inSummCardRecalc2, 0) = 0
     THEN
         RETURN;
     END IF;

     -- ��������
     IF COALESCE (inINN, '') = ''
     THEN
         RAISE EXCEPTION '������.� <%> �� ����������� ���� <���> � ����� Excel ��� ���� <%> <%> <%>.', inFIO, inSummCardRecalc1, inSummCardRecalc2, inSummNalogRecalc;
     END IF;


     -- ����� ����������
     vbPersonalId:= (WITH tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                                               , ROW_NUMBER() OVER (PARTITION BY ObjectString_INN.ValueData
                                                                    -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                                    ORDER BY CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectLink_Personal_PersonalServiceList.ChildObjectId > 0 THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                                           , CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                                           , ObjectLink_Personal_Member.ObjectId
                                                                   ) AS Ord
                                          FROM ObjectString AS ObjectString_INN
                                               INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                     ON ObjectLink_Personal_Member.ChildObjectId = ObjectString_INN.ObjectId
                                                                    AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                               INNER JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                                                                   AND Object_Personal.isErased = FALSE
                                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                                    ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                   AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                                          WHERE ObjectString_INN.ValueData = inINN
                                            AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
                                         )
                     --
                     SELECT tmpPersonal.PersonalId FROM tmpPersonal WHERE tmpPersonal.Ord = 1
                    );

     -- ��������
     IF COALESCE (vbPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� <%> �� ������ � ��� = <%> � ����� <%> <%> <%>.', inFIO, inINN, inSummCardRecalc1, inSummCardRecalc2, inSummNalogRecalc;
     END IF;

     -- ���������
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := gpSelect.Id
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := tmpPersonal.PersonalId
                                                        , inIsMain             := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain)
                                                        , inSummService        := COALESCE (gpSelect.SummService, 0)
                                                        , inSummCardRecalc     := COALESCE (inSummCardRecalc1, 0) + COALESCE (inSummCardRecalc2, 0)
                                                        , inSummNalogRecalc    := COALESCE (inSummNalogRecalc, 0)
                                                        , inSummMinus          := COALESCE (gpSelect.SummMinus, 0)
                                                        , inSummAdd            := COALESCE (gpSelect.SummAdd, 0)
                                                        , inSummHoliday        := COALESCE (gpSelect.SummHoliday, 0)
                                                        , inSummSocialIn       := COALESCE (gpSelect.SummSocialIn, 0)
                                                        , inSummSocialAdd      := COALESCE (gpSelect.SummSocialAdd, 0)
                                                        , inSummChild          := COALESCE (gpSelect.SummChild, 0)
                                                        , inComment            := COALESCE (gpSelect.Comment, '')
                                                        , inInfoMoneyId        := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101()) -- 60101 ���������� ����� + ���������� �����
                                                        , inUnitId             := tmpPersonal.UnitId
                                                        , inPositionId         := tmpPersonal.PositionId
                                                        , inMemberId               := gpSelect.MemberId                                     -- ��� ���� (���� ��������� ��������)
                                                        , inPersonalServiceListId  := ObjectLink_Personal_PersonalServiceList.ChildObjectId -- �� ������� ���������� ������������� �������� ��
                                                        , inUserId             := vbUserId
                                                         ) AS tmp
      FROM (SELECT View_Personal.PersonalId
                 , View_Personal.UnitId
                 , View_Personal.PositionId
                 , View_Personal.IsMain
            FROM Object_Personal_View AS View_Personal
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal
           LEFT JOIN gpSelect_MovementItem_PersonalService (inMovementId, FALSE, FALSE, inSession) AS gpSelect ON gpSelect.PersonalId = tmpPersonal.PersonalId
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpPersonal.PersonalId
                               AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
      LIMIT 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.01.17                                        *
 18.01.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Excel(inMovementId :=0 , inINN := '2565555555', inSum1 := 15 ::TFloat, inSum2 := 45 ::TFloat , inSession :='3':: TVarChar)