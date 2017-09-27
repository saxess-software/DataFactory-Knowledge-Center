
GRANT give somebody (usually to a database role, not to a specific user) the right to select data, execute a storedprocedure etc. 
Write this usually directly under the create statement to execute it always together. (as create will usually drop the object before and therefor also the rights)

GRANT SELECT for Views

GRANT SELECT ON OBJECT ::[dbo].[sx_pf_RESULT_Profit] TO pf_PlanningFactoryUser;
GRANT SELECT ON OBJECT ::[dbo].[sx_pf_RESULT_Profit] TO pf_PlanningFactoryService;



GRANT EXECUTE for Stored Procedures

GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_DELETE_User] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_DELETE_User] TO pf_PlanningFactoryService;