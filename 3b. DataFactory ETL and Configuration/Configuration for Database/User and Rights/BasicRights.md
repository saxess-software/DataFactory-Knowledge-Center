


If a user should have access to any custom object, it must GRANT Rights to the UserRoles:

#### For Procedures:

GO
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_cDistinctKostenstellen TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_cDistinctKostenstellen TO pf_PlanningFactoryService;

#### For Views:


GO
GRANT SELECT ON OBJECT ::sx_pf_DATAOUTPUT_cDistinctKostenstellen TO pf_PlanningFactoryUser;
GRANT SELECT ON OBJECT ::sx_pf_DATAOUTPUT_cDistinctKostenstellen TO pf_PlanningFactoryService;


Always put this statement under the View / Procedure Definition, but with the GO over them to start the new batch.
