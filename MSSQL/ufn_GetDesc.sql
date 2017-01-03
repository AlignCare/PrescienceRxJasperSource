/****** Object:  UserDefinedFunction [dbo].[ufn_GetDesc]    Script Date: 1/3/2017 11:22:53 AM ******/
DROP FUNCTION [dbo].[ufn_GetDesc]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetDesc]    Script Date: 1/3/2017 11:22:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_GetDesc] (@num int)
RETURNS varchar(9) 
AS
BEGIN

DECLARE @intDesc Table (num int PRIMARY KEY IDENTITY(1,1), description varchar(9))

INSERT INTO @intDesc VALUES ('Very Low'), ('Low'), ('Moderate'), ('High'), ('Very High')

RETURN (SELECT I.description
        FROM @intDesc I
        WHERE I.num = @num)
END

GO


