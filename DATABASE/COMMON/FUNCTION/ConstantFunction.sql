CREATE OR REPLACE FUNCTION zc_isHistoryCost_byInfoMoneyDetail() RETURNS Boolean AS $BODY$BEGIN RETURN (TRUE AND zc_isHistoryCost()); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_isHistoryCost() RETURNS Boolean AS $BODY$BEGIN RETURN (TRUE); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateEnd() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.01.2000'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_PartionGoods() RETURNS TDateTime AS $BODY$BEGIN RETURN ('18.03.2013'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_DateStart_ObjectCostOnUnit() RETURNS TDateTime AS $BODY$BEGIN RETURN ('01.10.2010'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_BarCodePref_Object() RETURNS TVarChar AS $BODY$BEGIN RETURN ('20100'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_Movement() RETURNS TVarChar AS $BODY$BEGIN RETURN ('20200'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_BarCodePref_MI() RETURNS TVarChar AS $BODY$BEGIN RETURN ('20300'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

/*
-- �������� ��� ��� �-��� ����� ������������ � Load_PostgreSql, ��� !!!������ �������� =0!!!
CREATE OR REPLACE FUNCTION zc_Measure_Sh() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Measure_Kg() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Goods_WorkIce() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Goods_ReWork() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_GoodsKind_WorkProgress() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_GoodsKind_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_BasisPrior() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_ProductionSeparate() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_PriceList_Bread() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_InfoMoneyDestination_WorkProgress() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Branch_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Juridical_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_FirstForm()  RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_FirstForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- CREATE OR REPLACE FUNCTION zc_Enum_PaidKind_SecondForm() RETURNS integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_PaidKind_SecondForm' AND DescId = zc_ObjectString_Enum()); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Color_Black() RETURNS Integer AS $BODY$BEGIN RETURN (0); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Red() RETURNS Integer AS $BODY$BEGIN RETURN (1118719); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Aqua() RETURNS Integer AS $BODY$BEGIN RETURN (16777158); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Cyan() RETURNS Integer AS $BODY$BEGIN RETURN (14862279); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_GreenL() RETURNS Integer AS $BODY$BEGIN RETURN (11987626); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Color_Yelow() RETURNS Integer AS $BODY$BEGIN RETURN (8978431); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

*/

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.14                                        * add rem zc_PriceList_Bread
 20.10.13                                        * add rem zc_Juridical_Basis
 22.09.13                                        * add rem zc_Branch_Basis
 09.08.13                                        * rem zc_PriceList_ProductionSeparate and zc_PriceList_Basis, ��� �-��� ���������� ��� �������� ������ (Load_PostgreSql.exe)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 06.08.13                                        * ? ��� ������� ��� � ��������� �-��� ������������ ����� �������� ������ (� �� ��� �������������� ��)
 21.07.13                                        * add zc_PriceList_ProductionSeparate and zc_PriceList_Basis
 16.07.13                                        *
 12.07.13                                        *
*/
