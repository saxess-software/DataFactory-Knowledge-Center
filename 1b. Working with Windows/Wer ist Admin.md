Wie kann ich auf einem lokalen PC prüfen ob ich Admin bin 
````
net user saxess
````
Wie kann ich auf einem lokalen PC ob ein anderer User Admin ist
````
net user anderer
````
Wie kann ich in der Domäne prüfen ob ich Admin bin
````
net user saxess \domain
````
Wie kann ich in der Domäne prüfen ob ich Admin bin
````
net user anderer \domain
````

Der Username wird immer one Domainangabe geschrieben. \domain wird so geschrieben und NICHT durch einen Domainnamen ersetzt. 
Diese Prüfung kann jeder user durchführen, er braucht dafür nicht selbst Admin sein.


