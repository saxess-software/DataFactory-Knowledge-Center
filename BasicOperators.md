
__+__ to add number or to conncatinat strings  
__-__ to substract number
__*__ to multiply  
__/__ for division
__%__ for modulo  (ganzzahliger Rest eg. 10 % 4 =2; Monat aus TimeID = 20170304 % 10000 / 100 = 3)
                                
                                
A lookup inside a XLS Formula can be done over a MatrixFormula like:
                                
=SVERWEIS(J51;{450.0,25;400.0,22;350.0,19;300.0,17;250.0,14;200.0,11;150.0,08;100.0,06};2;0)
          
          
Der Punkt ist in der MatrixFormel der Spaltentrenner.
          
          
