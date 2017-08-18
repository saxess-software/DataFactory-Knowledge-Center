Configuration must be done at the moment in Script sx_pf_GET_FactoryWebsites

	'https://www.datafactory.co/' AS WebsiteURL
  
  Website (must ?) be https protected, otherwise browser block the content due to mixed content (Main page has https, subpage seams to have this too).
  
  Press F12 in Webbrowser to see if a page from configuration is blocked.
  
  
  
## Configuration of Header
 
Views\Shared\_Layout.cshtml 

#FFFFFF

Content\site.css

ca. 5 stellen für Headerfarbe und objekte

Der Farbcode ist: 0, 101, 103
