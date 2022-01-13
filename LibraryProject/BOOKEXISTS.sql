/* Stored Procedure to Check if a Book number exists within the book table, and
	to see if said book number has been checked out or has been returned and is
	ready to be checked out														*/

CREATE OR ALTER PROCEDURE spBookReturn @BOOKNUM INT AS

DECLARE
	@MYBOOKNUM INT,
	@BOOKNUMEXISTS INT;
BEGIN TRANSACTION MYTRANSACTION
	
BEGIN 


	IF @MYBOOKNUM IN(SELECT BOOK_NUM
					 FROM FACT.BOOK
					 WHERE BOOK_NUM = @MYBOOKNUM)
		BEGIN
			SET @BOOKNUMEXISTS = 1;
		END
	ELSE
		BEGIN
			SET @BOOKNUMEXISTS = 0;
			PRINT 'Book does not exist';
		END
	IF @BOOKNUMEXISTS = 1
		BEGIN
			IF @MYBOOKNUM IN (SELECT BOOK_NUM
			FROM FACT.BOOK JOIN FACT.PATRON ON PATRON.PAT_ID = BOOK.PAT_ID)
				BEGIN
					UPDATE FACT.BOOK
					SET PAT_ID = NULL
					WHERE @MYBOOKNUM = BOOK_NUM;
					
					UPDATE FACT.CHECKOUT
					SET CHECK_IN_DATE = GETDATE()
					WHERE @MYBOOKNUM = BOOK_NUM;

					PRINT CONCAT(@MYBOOKNUM, ' ', 'has been returned')
					END;
		   ELSE
				PRINT CONCAT(@MYBOOKNUM,' ', 'is not checked out')
			END
			

END;
EXEC spBookReturn @MYBOOKNUM = 5257;
ROLLBACK TRANSACTION MYTRANSACTION
