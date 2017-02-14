
__+__ to add number or to conncatinat strings  
__-__ to substract number
__*__ to multiply  
__/__ for division
__%__ for modulo  (ganzzahliger Rest eg. 10 % 4 =2; Monat aus TimeID = 20170304 % 10000 / 100 = 3)
                                
      
      
      

#### Design of Excel Templates

A lookup inside a XLS Formula can be done over a MatrixFormula like:
                                
=SVERWEIS(J51;{450.0,25;400.0,22;350.0,19;300.0,17;250.0,14;200.0,11;150.0,08;100.0,06};2;0)
          

Der Punkt ist in der MatrixFormel der Spaltentrenner.


Don't use % for formating
* XLS Client will display value multiplied by 100 (eg. 66 if Cell Value is 0,66)
* WebClient just displays 0,66
* Database has 66 with scale 100 - so also 0,66 
* so XLS display value would be confusing
* better name the column % and use just a decimal place
