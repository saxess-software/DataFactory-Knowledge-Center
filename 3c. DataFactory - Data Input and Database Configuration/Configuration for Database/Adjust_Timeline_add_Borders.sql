/*
Script to reset the borders, which may be lost due to API Update
Maybe you wan't also adjust the timeline for all Products an add a year ? 
-> look for the "Adjust_Timeline_based_on_reference_product.sql" Script in the Knowledge center

*/

--BEGIN TRAN

UPDATE dT SET FormatID = 'sxTimeBorderNext' OUTPUT Deleted.*

FROM dbo.sx_pf_dTime dT
	LEFT JOIN dbo.sx_pf_dProducts dP
		ON dT.ProductKey = dP.ProductKey
WHERE 
	dT.TimeID % 10000 / 100 = 12
	AND dP.Template LIKE '%VM'
	
--ROLLBACK TRAN


