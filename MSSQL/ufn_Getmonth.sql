/****** Object:  UserDefinedFunction [dbo].[ufn_Getmonth]    Script Date: 1/3/2017 11:24:07 AM ******/
DROP FUNCTION [dbo].[ufn_Getmonth]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_Getmonth]    Script Date: 1/3/2017 11:24:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_Getmonth] (@num char(2))
RETURNS varchar(9) --since 'September' is the longest string, length 9
AS
BEGIN

DECLARE @intMonth Table (num int PRIMARY KEY IDENTITY(1,1), month varchar(9))

INSERT INTO @intMonth VALUES ('January'), ('February'), ('March'), ('April'), ('May')
                           , ('June'), ('July'), ('August') ,('September'), ('October')
                           , ('November'), ('December')

RETURN (SELECT I.month
        FROM @intMonth I
        WHERE I.num = CAST(@num AS INT))
END

GO


