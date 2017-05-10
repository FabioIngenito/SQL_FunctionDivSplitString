------------------------------
-- Desenvolvido por Durval Ramos
------------------------------
-- http://social.technet.microsoft.com/wiki/pt-br/contents/articles/24654.t-sql-dividindo-uma-string-em-multiplas-colunas.aspx
------------------------------
-- T-SQL: Dividindo uma String em múltiplas colunas
------------------------------
CREATE FUNCTION dbo.UFN_SEPARATES_COLUMNS(
@TEXT 
varchar(8000)
,@COLUMN    
tinyint
,@SEPARATOR char(1)
)RETURNS varchar(8000)
AS
  BEGIN
       DECLARE @POS_START  int = 1
       DECLARE @POS_END    int = CHARINDEX(@SEPARATOR, @TEXT, @POS_START)

        WHILE (@COLUMN >1 AND  @POS_END> 0)
         BEGIN
             SET @POS_START = @POS_END + 1
             SET @POS_END = CHARINDEX(@SEPARATOR, @TEXT, @POS_START)
             SET @COLUMN = @COLUMN - 1
         END 

        IF @COLUMN > 1  SET @POS_START  = LEN(@TEXT) + 1
       IF @POS_END = 0 SET @POS_END = LEN(@TEXT) + 1 

        RETURN SUBSTRING  (@TEXT,  @POS_START, @POS_END - @POS_START)
  END
GO
------------------------------
-- PARA TESTAR!
-- OBTÉM OS ELEMENTOS DE UMA ESTRUTURA "ISBN"
------------------------------
DECLARE @ISBN varchar(20) = '978-0-571-08989-5' 
SELECT
  dbo.UFN_SEPARATES_COLUMNS(@ISBN, 1, '-') AS PREFIX,
  dbo.UFN_SEPARATES_COLUMNS(@ISBN, 2, '-') AS REGISTRATION_GROUP,
  dbo.UFN_SEPARATES_COLUMNS(@ISBN, 3, '-') AS REGISTRANT,
  dbo.UFN_SEPARATES_COLUMNS(@ISBN, 4, '-') AS PUBLICATION,
  dbo.UFN_SEPARATES_COLUMNS(@ISBN, 5, '-') AS [CHECK]
GO
------------------------------
-- OUTRO TESTE (DUPLA SEPARAÇÃO):
------------------------------
DECLARE @BASE VARCHAR(300)
SELECT @BASE = '0.1,0.3,0.001;0.4,0.6,0.005;0.7,0.9,0.01'

SELECT dbo.UFN_SEPARATES_COLUMNS(@BASE, 1, ';'),
    dbo.UFN_SEPARATES_COLUMNS(dbo.UFN_SEPARATES_COLUMNS(@BASE, 1, ';'),1,','),
    dbo.UFN_SEPARATES_COLUMNS(dbo.UFN_SEPARATES_COLUMNS(@BASE, 1, ';'),2,','),
    dbo.UFN_SEPARATES_COLUMNS(dbo.UFN_SEPARATES_COLUMNS(@BASE, 1, ';'),3,',')
GO
------------------------------