-- Function: gpUpdate_Object_GoodsPropertyValue_Sh()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_Sh(Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_Sh(
    IN inId                  Integer,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inGoodsId             Integer,    -- ������
    IN inGoodsKindId         Integer,    -- ���� ������
    IN inisGoodsTypeKind     Boolean,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbisGoodsTypeKind  Boolean;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS());

   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;
  
   SELECT CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind
  INTO vbisGoodsTypeKind
   FROM Object_GoodsByGoodsKind_View
        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh
                             ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                            AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
   WHERE Object_GoodsByGoodsKind_View.GoodsId     = inGoodsId
     AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;

   ---
   IF inisGoodsTypeKind = TRUE AND vbisGoodsTypeKind = TRUE
   THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh(), inId, zc_Enum_GoodsTypeKind_Sh());
   ELSEIF inisGoodsTypeKind = TRUE AND vbisGoodsTypeKind = FALSE
   THEN
         RAISE EXCEPTION '������. � ��������� ������ <%> <%> �������� <%> ���.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (zc_Enum_GoodsTypeKind_Sh());
   ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh(), inId, Null);
   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.02.19         *
*/

-- ����
-- 

