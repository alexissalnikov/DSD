CREATE OR REPLACE FUNCTION zc_ObjectHistory_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_PriceListItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'zc_ObjectHistory_PriceListItem', '�����-����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_PriceListItem());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_JuridicalDetails() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_JuridicalDetails'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'zc_ObjectHistory_JuridicalDetails', '��������� ����������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_JuridicalDetails());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'zc_ObjectHistory_Price', '������ �� ����� � ��� �� �������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_Price());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_MarginCategoryItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_MarginCategoryItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'zc_ObjectHistory_MarginCategoryItem', '������� ��������� ������� (������� � ������)' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_MarginCategoryItem());

CREATE OR REPLACE FUNCTION zc_ObjectHistory_PriceChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDesc WHERE Code = 'zc_ObjectHistory_PriceChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDesc(Code, ItemName)
SELECT 'zc_ObjectHistory_PriceChange', '������ �� ����� �� �������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDesc WHERE Id = zc_ObjectHistory_PriceChange());

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 16.08.18         * zc_ObjectHistory_PriceChange
 09.02.17         * add zc_ObjectHistory_MarginCategoryItem
 22.12.15                                                          *zc_ObjectHistory_Price
 15.12.13                                        * !!!rename!!!
*/
